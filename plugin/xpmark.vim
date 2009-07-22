if exists("g:__XPMARK_VIM__")
    finish
endif
let g:__XPMARK_VIM__ = 1


com! XPMgetSID let s:sid =  matchstr("<SID>", '\zs\d\+_\ze')
XPMgetSID
delc XPMgetSID

runtime plugin/debug.vim
runtime plugin/xpreplace.vim


" probe mark
let g:xpm_mark = 'p'
let g:xpm_mark_nextline = 'l'
let g:xpm_changenr_level = 1000
let s:insertPattern = '[i]'

" TODO 'au matchparen' causes it to update 2 or 3 times for each cursor move
" TODO sorted updating for speeding up.
" TODO for mode 'R', nothing needed to do
" TODO joining lines cause marks lost


let s:log = CreateLogger( 'debug' )
" let s:log = CreateLogger( 'warn' )





fun! XPMadd( name, pos, prefer ) "{{{
    " @param name       mark name
    "
    " @param pos        list of [ line, column ]
    "
    " @param prefer     'l' or 'r' to indicate this mark is left-prefered or
    "                   right-prefered. Typing on a left-prefered mark add text
    "                   after mark, before mark for right-prefered.
    "                   Default : 'l' left-prefered

    call s:log.Log( "add mark of name " . string( a:name ) . ' at ' . string( a:pos ) )
    let d = s:bufData()
    let prefer = a:prefer == 'l' ? 0 : 1
    let d.marks[ a:name ] = a:pos + [ len( getline( a:pos[0] ) ), prefer ]

    call d.addMarkOrder( a:name )

endfunction "}}}


fun! XPMhere( name, prefer ) "{{{
    call XPMadd( a:name, [ line( "." ), col( "." ) ], a:prefer )
endfunction "}}}

fun! XPMremove( name ) "{{{
    let d = s:bufData()
    call d.removeMark( a:name )
endfunction "}}}

fun! XPMremoveMarkStartWith(prefix) "{{{
    let d = s:bufData()
    for key in keys( d.marks )
        if key =~# '^\V' . a:prefix
            call d.removeMark( key )
        endif
    endfor
endfunction "}}}

fun! XPMflush() "{{{
    let d = s:bufData()
    let d.marks = {}
    let d.orderedMarks = []
    let d.markHistory[ changenr() ] = { 'dict' : d.marks, 'list': d.orderedMarks }
endfunction "}}}

fun! XPMgoto( name ) "{{{
    let d = s:bufData()
    if has_key( d.marks, a:name )
        let pos = d.marks[ a:name ][ : 1 ]
        call cursor( pos )
    endif
endfunction "}}}

fun! XPMpos( name ) "{{{
    let d = s:bufData()
    if has_key( d.marks, a:name )
        return d.marks[ a:name ][ : 1 ]
    endif
    return [0, 0]
endfunction "}}}

" TODO set likely between in xpt
fun! XPMsetLikelyBetween( start, end ) "{{{
    let d = s:bufData()
    call s:log.Debug( 'parameters : ' . a:start . ' ' . a:end )
    Assert has_key( d.marks, a:start )
    Assert has_key( d.marks, a:end )
    let d.changeLikelyBetween = { 'start' : a:start, 'end' : a:end }
endfunction "}}}

fun! XPMsetUpdateStrategy( mode ) "{{{
    " 'manual'		: no update takes unless call directly to XPMupdate()  
    " 'auto'    	: update on any movements
    " 'insertMode'	: update only when action taken in insert mode
    " 'normalMode'	: update when action taken in normal mode, just leaving
    "                     normal mode, or just entering normal mode.
    let d = s:bufData()
    if a:mode == 'manual'
        " manual mode
        let d.updateStrategy = a:mode

    elseif a:mode == 'normalMode'
        let d.updateStrategy = a:mode

    elseif a:mode == 'insertMode'
        let d.updateStrategy = a:mode

    else
        " auto mode
        let d.updateStrategy = 'auto'
    endif
endfunction "}}}

fun! XPMupdateSpecificChangedRange(start, end) " {{{
    let d = s:bufData()

    let nr = changenr()

    call s:log.Log( "update specific range" )

    if nr != d.lastChangenr
        call d.snapshot()
    endif

    call d.initCurrentStat()
    call d.updateWithNewChangeRange( a:start, a:end )
    call d.saveCurrentStat()

endfunction " }}}

fun! XPMautoUpdate(msg) "{{{
    call s:log.Debug( 'XPMautoUpdate from ' . a:msg )
    if !exists( 'b:_xpmark' )
        return ''
    endif


    " TODO not complete strategy
    let d = s:bufData()
    let isInsertMode = (d.lastMode == 'i' && mode() == 'i')
    if d.updateStrategy == 'manual' 
                \ || d.updateStrategy == 'normalMode' && isInsertMode
                \ || d.updateStrategy == 'insertMode' && !isInsertMode

        " call d.saveCurrentStat()
        return ''
    endif

    return XPMupdate('auto')
endfunction "}}}

fun! XPMupdate(...) " {{{
    if !exists( 'b:_xpmark' )
        return ''
    endif

    let d = s:bufData()

    let needUpdate = d.isUpdateNeeded()

    if !needUpdate
        call d.saveCurrentCursorStat()
        return ''
    endif



    call d.initCurrentStat()


    if d.lastMode =~ s:insertPattern && d.stat.mode =~ s:insertPattern
        " stays in insert mode 
        call d.insertModeUpdate()

    else
        " *) just entered insert mode or just leave insert-like mode
        " *) stays in normal mode 
        call d.normalModeUpdate()

    endif


    call d.saveCurrentStat()

    return ''
endfunction "}}}

fun! XPMupdateStat() "{{{
    call s:log.Log( " --------step--------- " )

    let d = s:bufData()

    call d.saveCurrentStat()
endfunction "}}}

fun! XPMupdateCursorStat(...) "{{{
    call s:log.Log( " --------step--------- " )

    let d = s:bufData()

    call d.saveCurrentCursorStat()

endfunction "}}}

fun! XPMsetBufSortFunction( funcRef ) "{{{
    let b:_xpm_compare = a:funcRef
endfunction "}}}

fun! XPMallMark() "{{{
    let d = s:bufData()

    let msg = ''
    " for name in sort( keys( d.marks ) )
    for name in d.orderedMarks
        let msg .= name . repeat( '-', 30-len( name ) ) . " : " . substitute( string( d.marks[ name ] ), '\<\d\>', ' &', 'g' ) . "\n"
    endfor
    return msg
endfunction "}}}



fun! s:isUpdateNeeded() dict "{{{

    if empty( self.marks ) && changenr() == self.lastChangenr
        " not undo/redo action, and no mark defined
        return 0
    endif

    return 1
endfunction "}}}

fun! s:initCurrentStat() dict "{{{
    let self.stat = {
                \    'currentPosition'  : [ line( '.' ), col( '.' ) ],
                \    'totalLine'        : line( "$" ),
                \    'currentLineLength': len( getline( "." ) ),
                \    'mode'             : mode(),
                \    'positionOfMarkP'  : [ line( "'" . g:xpm_mark ), col( "'" . g:xpm_mark ) ] 
                \}
endfunction "}}}

fun! s:snapshot() dict "{{{
    call s:log.Log( "take snapshot" )
    let nr = changenr()

    call s:log.Log( 'snapshot at :' . nr )

    let n = self.lastChangenr + 1
    while n < nr
        call s:log.Info( 'to link markHistory ' . n . ' to ' .(n - 1) )
        let self.markHistory[ n ] = self.markHistory[ n - 1 ]

        " clean the old
        if has_key( self.markHistory,  n - g:xpm_changenr_level )
            unlet self.markHistory[ n - g:xpm_changenr_level ]
        endif
        let n += 1
    endwhile

    let self.marks = copy( self.marks )
    let self.orderedMarks = copy( self.orderedMarks )
    let self.markHistory[ nr ] = { 'dict' : self.marks, 'list': self.orderedMarks }


endfunction "}}}

fun! s:handleUndoRedo() dict "{{{
    " return 1 : It is undo/redo action
    "        0 : It is normal action

    let nr = changenr()

    if nr < self.lastChangenr
        " undo action "{{{

        call s:log.Log( "undo" )


        if has_key( self.markHistory, nr )
            let self.marks = self.markHistory[ nr ].dict
            let self.orderedMarks = self.markHistory[ nr ].list
        else
            call s:log.Info( 'u : no ' . nr . ' in markHistory, create new mark set' )
            let self.marks = {}
            let self.orderedMarks = []
        endif

        return 1

        "}}}

    elseif nr > self.lastChangenr && nr <= self.changenrRange[1]
        " redo action "{{{

        call s:log.Log( "redo" )

        if has_key( self.markHistory, nr )
            let self.marks = self.markHistory[ nr ].dict
            let self.orderedMarks = self.markHistory[ nr ].list
        else
            call s:log.Info( "<C-r> no " . nr . ' in markHistory, create new mark set' )
            let self.marks = {}
            let self.orderedMarks = []
        endif

        return 1

        "}}}

    else
        " not an undo/redo action 
        return 0

    endif
endfunction "}}}

fun! s:insertModeUpdate() dict "{{{

    call s:log.Log( "update Insert" )

    if self.handleUndoRedo()
        return
    endif


    let stat = self.stat

    if changenr() != self.lastChangenr
        call self.snapshot()
    endif

    let lastPos = self.lastPositionAndLength[ : 1 ]
    let bLastPos = [ self.lastPositionAndLength[0] + stat.totalLine - self.lastTotalLine, 0 ]
    let bLastPos[1] = self.lastPositionAndLength[1] - self.lastPositionAndLength[2] + len( getline( bLastPos[0] ) )

    call s:log.Log( 'lastPos=' . string( lastPos ) )
    call s:log.Log( 'bLastPos=' . string( bLastPos ) )

    " TODO deal with <C-j>, <C-k>
    if bLastPos[0] * 10000 + bLastPos[1] >= lastPos[0] * 10000 + lastPos[1]

        " content added 
        call s:log.Log( "content added" )
        call self.updateWithNewChangeRange( self.lastPositionAndLength[ :1 ], stat.currentPosition )

    else
        " deletion 
        " TODO check if current position is really before last position
        call s:log.Log( "content removed" )
        call self.updateWithNewChangeRange( stat.currentPosition, stat.currentPosition )


    endif


endfunction "}}}

fun! s:normalModeUpdate() dict "{{{
    let stat = self.stat

    let nr = changenr()

    if nr == self.lastChangenr
        " no change was taken to buffer 
        return
    endif


    call s:log.Log( "update Normal" )


    if self.handleUndoRedo()
        return
    endif

    let cs = [ line( "'[" ), col( "'[" ) ]
    let ce = [ line( "']" ), col( "']" ) ]



    " normal action

    call self.snapshot()


    let diffOfLine = stat.totalLine - self.lastTotalLine

    " NOTE: when just enter insert mode, change-range is not valid
    if stat.mode =~ s:insertPattern
        " just entered insert mode "{{{
        " Maybe 'o' or 'O' command

        call s:log.Log( 'just insert mark p=' . string( [ line( "'p" ), col( "'p" ) ] ) )

        if diffOfLine > 0

            if self.lastPositionAndLength[0] < stat.positionOfMarkP[0]
                " 'O' 
                call self.updateMarksAfterLine( self.lastPositionAndLength[0] - 1 )

            else
                " 'o' ?  
                call self.updateMarksAfterLine( stat.currentPosition[0] - 1 )
            endif

        elseif self.lastMode =~ 's' || self.lastMode == "\<C-s>"
            " from select mode, entering something
            " NOTE: if 'a' is mapped, and 'abbb' is typed, the first typing
            " will not trigger any updates.

            call s:log.Log( "update from select mode" )
            call self.updateWithNewChangeRange([ line( "'<" ), col( "'<" ) ], stat.currentPosition)


        else
            " command 's'?
            " mark p may be deleted
            " is that a linewise deletion?
            " TODO 

            call s:log.Log( "update for 's' command or else" )
            call self.updateWithNewChangeRange(stat.currentPosition, stat.currentPosition)

        endif

        "}}}

    elseif self.lastMode =~ s:insertPattern
        " just left insert mode "{{{
        " nothing to do, everything is ok in insert mode
        " }}}

    else
        " change is taken in normal mode "{{{
        " delete, replace, paste 




        " TODO change range!!
        " The actual changed range is [cs, ce - 1]. 
        " And ce is always [ n, 1 ], that means changed range is lines
        " between cs[0] to ce[0] - 1
        "



        " Linewise deletion, '[ and '] may be wrong if 'startofline' set
        " to be 0 and the command is 'dd'.
        "
        " Only linewise deletion removes mark.

        let linewiseDeletion =  stat.positionOfMarkP[0] == 0

        call s:log.Log( "is linewise deletion :" . linewiseDeletion )

        let lineNrOfChangeEndInLastStat = ce[0] - diffOfLine

        if linewiseDeletion
            if cs == ce
                " linewise deletion "{{{

                call s:log.Log( 'linewise deletion range : ' . string( [ cs[0], lineNrOfChangeEndInLastStat ] ) )

                call self.updateForLinewiseDeletion(cs[0], lineNrOfChangeEndInLastStat)

                return
                "}}}

            else
                " replace, paste
                " same with normal changing, nothing to do
            endif

        elseif stat.positionOfMarkP[0] == line( "'" . g:xpm_mark_nextline ) 
                    \&& stat.totalLine < self.lastTotalLine
            " join single line
            " TODO join multi lines

            call s:log.Debug( 'update with line join' )

            let endPos = [ self.lastPositionAndLength[0], self.lastPositionAndLength[2] ]
            call self.updateWithNewChangeRange( endPos, endPos )

            return

        elseif cs == [1, 1] && ce == [ stat.totalLine, 1 ]
            " TODO to test if it is OK with buffer of only 1 line
            " substitute or other globally-affected command
            call s:log.Log( "substitute, remove all marks" )
            call XPMflush()
            return

        endif

        call self.updateWithNewChangeRange(cs, ce)


        "}}}

    endif


endfunction "}}}

fun! s:updateMarksAfterLine(line) dict "{{{
    let diffOfLine = self.stat.totalLine - self.lastTotalLine

    for [ n, v ] in items( self.marks )
        if v[0] > a:line
            let self.marks[ n ] = [ v[0] + diffOfLine, v[1], v[2], v[3] ]
        endif
    endfor
endfunction "}}}

fun! s:updateForLinewiseDeletion( fromLine, toLine ) dict "{{{
    for [n, mark] in items( self.marks )

        if mark[0] >= a:toLine
            let self.marks[ n ] = [ mark[0] + self.stat.totalLine - self.lastTotalLine, mark[1], mark[2], mark[3] ]

        elseif mark[0] >= a:fromLine && mark[0] < a:toLine
            call s:log.Log( 'remove mark at position:' . string( mark ) )
            call remove( self.marks, n )

        endif
    endfor
endfunction "}}}

fun! s:updateWithNewChangeRange( changeStart, changeEnd ) dict "{{{

    call s:log.Log( "parameters : " . string( [ a:changeStart, a:changeEnd ] ) )
    call s:log.Debug( 'self:' . string( self ) )


    let bChangeEnd = [ a:changeEnd[0] - self.stat.totalLine, 
                \ a:changeEnd[1] - len( getline( a:changeEnd[0] ) ) ]


    " try to find out the marks most likely to be 

    let likelyIndexes = self.findLikelyRange( a:changeStart, bChangeEnd )
    if likelyIndexes == [ -1, -1 ]
        " no likely marks matches

        let indexes = [0, len( self.orderedMarks )]
        call self.updateMarks( indexes, a:changeStart, a:changeEnd )

    else
        let len = len( self.orderedMarks )
        let i = likelyIndexes[0]
        let j = likelyIndexes[1]
        call self.updateMarksBefore( [0, i + 1], a:changeStart, a:changeEnd )
        call self.updateMarks( [i+1, j],   a:changeStart, a:changeEnd )
        call self.updateMarksAfter( [j+1, len], a:changeStart, a:changeEnd )

    endif


endfunction "}}}

fun! s:updateMarksBefore( indexRange, changeStart, changeEnd ) dict "{{{
    let lineLengthCS    = len( getline( a:changeStart[0] ) )

    call s:log.Log( string( a:changeEnd ), self.stat.totalLine )

    let [ iStart, iEnd ] = [ a:indexRange[0] - 1, a:indexRange[1] - 1 ]
    while iStart < iEnd
        let iStart += 1

        let name = self.orderedMarks[ iStart ]

        let mark = self.marks[ name ]
        let bMark = [ mark[0] - self.lastTotalLine, mark[1] - mark[2] ]

        call s:log.Debug( "mark:" . name . ' is ' . string( mark ) )
        call s:log.Debug( "bMark:" . string( bMark ) )

        if mark[0] < a:changeStart[0] 
            " before changed lines
            call s:log.Debug( "before change" )
            continue

        elseif mark[0] == a:changeStart[0] && mark[1] - 1 < a:changeStart[1]
            " change spans only right part of mark
            " update length only

            call s:log.Debug( 'span right part' )
            let self.marks[ name ] = [ mark[0], mark[1], lineLengthCS, mark[3] ]

        else
            call s:log.Error( 'mark should be before, but it is after start of change' )

        endif

        call s:log.Debug( "updated mark : " . (has_key( self.marks, name ) ? string( self.marks[ name ] ) : '' ) )

    endwhile

endfunction "}}}

fun! s:updateMarksAfter( indexRange, changeStart, changeEnd ) dict "{{{
    let bChangeEnd = [ a:changeEnd[0] - self.stat.totalLine, 
                \ a:changeEnd[1] - len( getline( a:changeEnd[0] ) ) ]

    let diffOfLine = self.stat.totalLine - self.lastTotalLine

    let lineLengthCS    = len( getline( a:changeStart[0] ) )
    let lineLengthCE    = len( getline( a:changeEnd[0] ) )

    call s:log.Log( string( a:changeEnd ), self.stat.totalLine )
    call s:log.Debug( "diffOfLine :" . diffOfLine )
    call s:log.Debug( "bChangeEnd:" . string( bChangeEnd ) )

    let lineNrOfChangeEndInLastStat = a:changeEnd[0] - diffOfLine
    call s:log.Debug( "lineNrOfChangeEndInLastStat :" . lineNrOfChangeEndInLastStat )

    let [ iStart, iEnd ] = [ a:indexRange[0] - 1, a:indexRange[1] - 1 ]

    while iStart < iEnd
        let iStart += 1

        let name = self.orderedMarks[ iStart ]

        let mark = self.marks[ name ]
        let bMark = [ mark[0] - self.lastTotalLine, mark[1] - mark[2] ]

        call s:log.Debug( "mark:" . name . ' is ' . string( mark ) )
        call s:log.Debug( "bMark:" . string( bMark ) )

        if mark[0] > lineNrOfChangeEndInLastStat
            " after changed lines
            let self.marks[ name ] = [ mark[0] + diffOfLine, mark[1], mark[2], mark[3] ]
            call s:log.Debug( 'after change:' . string( mark ) )

        elseif bMark[0] == bChangeEnd[0] && bMark[1] >= bChangeEnd[1]
            " change spans only left part of mark 
            call s:log.Debug( 'span left part' )
            let self.marks[ name ] = [ a:changeEnd[0], bMark[1] + lineLengthCE, lineLengthCE, mark[3] ]

        else
            call s:log.Error( 'mark should be After changes, but it is before them.' )

        endif

        call s:log.Debug( "updated mark : " . (has_key( self.marks, name ) ? string( self.marks[ name ] ) : '' ) )

    endwhile

    call s:log.Log( 'updateMarksAfter DONE' )

endfunction "}}}

fun! s:updateMarks( indexRange, changeStart, changeEnd ) dict "{{{
    let bChangeEnd = [ a:changeEnd[0] - self.stat.totalLine, 
                \ a:changeEnd[1] - len( getline( a:changeEnd[0] ) ) ]

    let diffOfLine = self.stat.totalLine - self.lastTotalLine

    let lineLengthCS    = len( getline( a:changeStart[0] ) )
    let lineLengthCE    = len( getline( a:changeEnd[0] ) )

    call s:log.Log( string( a:changeEnd ), self.stat.totalLine )
    call s:log.Debug( "diffOfLine :" . diffOfLine )
    call s:log.Debug( "bChangeEnd:" . string( bChangeEnd ) )

    let lineNrOfChangeEndInLastStat = a:changeEnd[0] - diffOfLine
    call s:log.Debug( "lineNrOfChangeEndInLastStat :" . lineNrOfChangeEndInLastStat )

    let [ iStart, iEnd ] = [ a:indexRange[0] - 1, a:indexRange[1] - 1 ]

    while iStart < iEnd
        let iStart += 1

        let name = self.orderedMarks[ iStart ]

        let mark = self.marks[ name ]
        let bMark = [ mark[0] - self.lastTotalLine, mark[1] - mark[2] ]

        call s:log.Debug( "mark:" . name . ' is ' . string( mark ) )
        call s:log.Debug( "bMark:" . string( bMark ) )

        if mark[0] < a:changeStart[0] 
            " before changed lines
            call s:log.Debug( "before change" )
            continue

        elseif mark[0] > lineNrOfChangeEndInLastStat
            " after changed lines
            let self.marks[ name ] = [ mark[0] + diffOfLine, mark[1], mark[2], mark[3] ]
            call s:log.Debug( 'after change:' . string( mark ) )


        elseif mark[ 0 : 1 ] == a:changeStart && bMark == bChangeEnd
            " between mark

            if mark[3] == 0
                " left mark 
                " update line length only
                let self.marks[ name ] = [ mark[0], mark[1], lineLengthCS, 0 ]
                call s:log.Debug( 'between mark, left mark' )

            else
                " right mark 

                let self.marks[ name ] = [ a:changeEnd[0], bMark[1] + lineLengthCE, lineLengthCE, 1 ]
                call s:log.Debug( 'between mark, right mark' )


            endif

        elseif mark[0] == a:changeStart[0] && mark[1] - 1 < a:changeStart[1]
            " change spans only right part of mark
            " update length only

            call s:log.Debug( 'span right part' )
            let self.marks[ name ] = [ mark[0], mark[1], lineLengthCS, mark[3] ]

        elseif bMark[0] == bChangeEnd[0] && bMark[1] >= bChangeEnd[1]
            " change spans only left part of mark 
            call s:log.Debug( 'span left part' )
            let self.marks[ name ] = [ a:changeEnd[0], bMark[1] + lineLengthCE, lineLengthCE, mark[3] ]

        else
            " change overides mark
            call s:log.Debug( 'override mark' )

            call self.removeMark( name )

            let iStart -= 1
            let iEnd -= 1

        endif

        call s:log.Debug( "updated mark : " . (has_key( self.marks, name ) ? string( self.marks[ name ] ) : '' ) )

    endwhile

endfunction "}}}

" XXX 
fun! XPMupdateWithMarkRangeChanging( startMark, endMark, changeStart, changeEnd ) "{{{
    let d = s:bufData()

    call d.initCurrentStat()
    " if d.handleUndoRedo()
        " return
    " endif
    if changenr() != d.lastChangenr
        call d.snapshot()
    endif

    let startIndex = index( d.orderedMarks, a:startMark )
    Assert startIndex >= 0

    let endIndex = index( d.orderedMarks, a:endMark, startIndex + 1 )
    Assert endIndex >= 0

    call s:log.Log( 'update between marks :' . a:startMark . '-' . a:endMark . ' indexes are:' . string( [ startIndex, endIndex ] ) )

    call d.updateMarksAfter( [ endIndex, len( d.orderedMarks ) ], a:changeStart, a:changeEnd )

    let [ i, len ] = [ startIndex + 1 , endIndex  ]

    while i < len
        let len -= 1
        let mark = d.orderedMarks[ i ]
        call d.removeMark( mark )
    endwhile

    let lineLength = len( getline( a:changeStart[0] ) )
    let [ i ] = [ startIndex + 1 ]
    while i > 0
        let i -= 1

        let mark = d.orderedMarks[ i ]

        if d.marks[ mark ][1] < a:changeStart[0]
            break
        else
            let d.marks[ mark ][2] = lineLength
        endif

    endwhile

    call d.saveCurrentStat()

endfunction "}}}


fun! s:findLikelyRange(changeStart, bChangeEnd) dict "{{{
    if self.changeLikelyBetween.start == ''
                \ || self.changeLikelyBetween.end == ''
        return [ -1, -1 ]
    endif


    let [ likelyStart, likelyEnd ] = [ self.marks[ self.changeLikelyBetween.start ], 
                \ self.marks[ self.changeLikelyBetween.end ] ]

    let bLikelyEnd = [ likelyEnd[0] - self.lastTotalLine, 
                \ likelyEnd[1] - likelyEnd[2] ]

    let nChangeStart = a:changeStart[0] * 10000 + a:changeStart[1]
    let nLikelyStart = likelyStart[0] * 10000 + likelyStart[1]

    let nbChangeEnd = a:bChangeEnd[0] * 10000 + a:bChangeEnd[1]
    let nbLikelyEnd = bLikelyEnd[0] * 10000 + bLikelyEnd[1]

    call s:log.Log( 'likely range=' . string( [ likelyStart, likelyEnd, bLikelyEnd ] ) )
    call s:log.Log( 'change range=' . string( [ a:changeStart, a:bChangeEnd ] ) )

    if nChangeStart >= nLikelyStart && nbChangeEnd <= nbLikelyEnd
        call s:log.Log( 'change happened between the intent marks' )

        let re = []
        let [i, len] = [0, len( self.orderedMarks )]
        while i < len
            if self.orderedMarks[ i ] == self.changeLikelyBetween.start
                call add( re, i )
            elseif self.orderedMarks[ i ] == self.changeLikelyBetween.end
                call add( re, i )
                return re
            endif

            let i += 1
        endwhile

        call s:log.Error( string( self.changeLikelyBetween ) . ' : end mark is not found!' )

    else
        return [ -1, -1 ]

    endif

endfunction "}}}


fun! s:saveCurrentCursorStat() dict "{{{

    call s:log.Debug( 'saveCurrentCursorStat' )

    let p = [ line( '.' ), col( '.' ) ]

    if p != self.lastPositionAndLength[ : 1 ]
        let self.lastPositionAndLength = p + [ len( getline( "." ) ) ]

        " NOTE: weird, 'normal! ***' causes exception in select mode. but 'k'
        " command is ok

        " if mode() ==? 's' || mode() == "\<C-s>" 
            exe 'k'.g:xpm_mark
            if p[0] < line( '$' )
                exe '+1k' . g:xpm_mark_nextline
            else
                exe 'delmarks ' . g:xpm_mark_nextline
            endif

        " else 
            " exe 'silent! normal! m' . g:xpm_mark
        " endif 

        " call s:log.Log( 'updated lastPositionAndLength:' . string(self.lastPositionAndLength) )
    endif

    let self.lastMode = mode()

endfunction "}}}

" TODO rename me
fun! s:saveCurrentStat() dict " {{{

    call self.saveCurrentCursorStat()

    let self.lastChangenr = changenr()

    let self.changenrRange[0] =  min( [ self.lastChangenr, self.changenrRange[0] ] )
    let self.changenrRange[1] =  max( [ self.lastChangenr, self.changenrRange[1] ] )

    let self.lastTotalLine = line( "$" )

endfunction " }}}

" TODO call back
fun! s:removeMark(name) dict "{{{
    call s:log.Info( "removed mark:" . a:name )
    if !has_key( self.marks, a:name )
        return
    endif
    if self.changeLikelyBetween.start == a:name 
                \ || self.changeLikelyBetween.end == a:name
        let self.changeLikelyBetween = { 'start' : '', 'end' : '' }
    endif
    call filter( self.orderedMarks, 'v:val != ' . string( a:name ) )
    call remove( self.marks, a:name )
endfunction "}}}

fun! s:addMarkOrder( name ) dict "{{{
    let markToAdd = self.marks[ a:name ]

    let nPos = markToAdd[0] * 10000 + markToAdd[1]

    let i = -1
    for n in self.orderedMarks
        let i += 1
        let mark = self.marks[ n ]
        let nMark = mark[0] * 10000 + mark[1]
        call s:log.Debug( 'nMark=' . nMark, 'nPos=' . nPos )
        if nMark == nPos
            let cmp = self.compare( a:name, n )
            if cmp == 0
                throw 'XPM : overlapped mark:' . a:name . '=' . string(markToAdd) . ' and ' . n . '=' . string( mark ) 

            elseif cmp > 0
                continue

            else
                " cmp < 0 

                call insert( self.orderedMarks, a:name, i )
                return

            endif


        elseif nPos < nMark
            call s:log.Debug( 'small than' . n )
            
            call insert( self.orderedMarks, a:name, i )
            return

        endif

    endfor

    call add ( self.orderedMarks, a:name )

endfunction "}}}

fun! s:compare( a, b ) dict "{{{
    if exists( 'b:_xpm_compare' )
        return b:_xpm_compare( self, a:a, a:b )
    else
        return s:defaultCompare( self, a:a, a:b )
    endif
endfunction "}}}

fun! s:ClassPrototype(...) "{{{
    let p = {}
    for name in a:000
        let p[ name ] = function( '<SNR>' . s:sid . name )
    endfor

    return p
endfunction "}}}

let s:prototype =  s:ClassPrototype(
            \    'isUpdateNeeded',
            \    'initCurrentStat',
            \    'snapshot',
            \    'handleUndoRedo',
            \    'insertModeUpdate',
            \    'normalModeUpdate',
            \    'saveCurrentStat',
            \    'saveCurrentCursorStat',
            \    'updateMarksAfterLine',
            \    'updateForLinewiseDeletion',
            \    'updateWithNewChangeRange',
            \    'removeMark',
            \    'findLikelyRange', 
            \    'addMarkOrder',
            \    'updateMarks', 
            \    'updateMarksBefore', 
            \    'updateMarksAfter', 
            \    'compare',
            \)

fun! s:initBufData() "{{{
    let nr = changenr()
    let b:_xpmark = { 
                \ 'updateStrategy'       : 'auto', 
                \ 'stat'                 : {},
                \ 'orderedMarks'         : [],
                \ 'marks'                : {},
                \ 'markHistory'          : {}, 
                \ 'changeLikelyBetween'  : { 'start' : '', 'end' : '' }, 
                \ 'lastMode'             : 'n',
                \ 'lastPositionAndLength': [ line( '.' ), col( '.' ), len( getline( '.' ) ) ],
                \ 'lastTotalLine'        : line( '$' ),
                \ 'lastChangenr'         : nr,
                \ 'changenrRange'        : [nr, nr], 
                \ }

    let b:_xpmark.markHistory[ nr ] = { 'dict' : b:_xpmark.marks, 'list' : b:_xpmark.orderedMarks }



    call extend( b:_xpmark, s:prototype, 'force' )

    exe 'k' . g:xpm_mark
    if line( '.' ) < line( '$' )
        exe '+1k' . g:xpm_mark_nextline
    else
        exe 'delmarks ' . g:xpm_mark_nextline
    endif
endfunction "}}}

fun! s:bufData() "{{{
    if !exists('b:_xpmark')
        call s:initBufData()
    endif

    return b:_xpmark
endfunction "}}}

fun! s:defaultCompare(d, markA, markB) "{{{
    let [ ma, mb ] = [ a:d.marks[ a:markA ], a:d.marks[ a:markB ] ]
    let nMarkA = ma[0] * 10000 + ma[1]
    let nMarkB = mb[0] * 10000 + mb[1]

    return (nMarkA - nMarkB) != 0 ? (nMarkA - nMarkB) : (a:d.marks[ a:markA ][3] - a:d.marks[ a:markB ][3])
endfunction "}}}

fun! PrintDebug()
    let d = s:bufData()

    let debugString  = changenr()
    let debugString .= ' p:' . string( getpos( "'" . g:xpm_mark )[ 1 : 2 ] )
    let debugString .= ' ' . string( [[ line( "'[" ), col( "'[" ) ], [ line( "']" ), col( "']" ) ]] ) . " "
    let debugString .= " " . mode() . string( [line( "." ), col( "." )] ) . ' last:' .string( d.lastPositionAndLength )

    return substitute( debugString, '\s', '' , 'g' )
endfunction



let s:count = 0
fun! Count()
    let s:count += 1
    let symbol = '|/-\'
    return ' ' . repeat( symbol[ s:count % 4 ], 4 ) . ' ' . s:count . ' '
endfunction


" set statusline=%#DiffText#%{Count()}%0*
" set statusline+=%{XPMautoUpdate('..')}
" set statusline+=%{PrintDebug()}
" set ruf=%{PrintDebug()}
" set statusline=


nnoremap ,m :call XPMhere('c')<cr>
nnoremap ,M :call XPMhere('c','r')<cr>
nnoremap ,g :call XPMgoto('c')<cr>




if &ruler && &rulerformat == ""
    " ruler set but rulerformat is set to be default 
    set rulerformat=%17(%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P%)

elseif !&ruler
    " if no ruler set, display none 
    set rulerformat=

endif

" Always enable ruler so that if statusline disabled, update can be done
" through rulerformat
set ruler

let &rulerformat .= '%{XPMautoUpdate("ruler")}'

let &statusline   = '%{PrintDebug()}' . &statusline
let &statusline  .= '%{XPMautoUpdate("statusline")}'


" test range
"
" 000000000000000000000000000000000000000
" 111111111111111111111111111111111111111
" 222222222222222222222222222222222222222
" 33333333333*333333333333333333333333333
" 444444444444444444444444444444444444444
" 555555555555555555555555555555555555555
"
"
" left-prefered:
" ----*----
" xxxx
"     xxxx
"
" right-prefered:
" ----*----
" xxxxx
"      xxx

fun! XPMtest()
    call XPreplace( [477, 10], [478, 5], '=' )
    call XPreplace( [481, 10], [481, 11], '+' )
endfunction






" vim: set sw=4 sts=4 :
