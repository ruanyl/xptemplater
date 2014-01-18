" TODO entity char
" TODO back at 'base'
XPTemplate priority=lang

let s:f = g:XPTfuncs()

XPTinclude
      \ _common/common
      \ xml/xml



XPTvar $CURSOR_PH 

XPTvar $CL    <!--
XPTvar $CM
XPTvar $CR      -->
XPTinclude
      \ _comment/doubleSign

XPTembed
      \ javascript/javascript
      \ css/css

" ========================= Function and Variables =============================



fun! s:f.createTable(...) "{{{
    let nrow_str = inputdialog("num of row:")
    let nrow = nrow_str + 0

    let ncol_str = inputdialog("num of column:")
    let ncol = ncol_str + 0

    let l = ""
    let i = 0 | while i < nrow | let i += 1
        let j = 0 | while j < ncol | let j += 1
            let l .= "<tr>\n<td id=\"`pre^_".i."_".j."\"></td>\n</tr>\n"
        endwhile
    endwhile
    return "<table id='`id^'>\n".l."</table>"
endfunction "}}}


let s:doctypes = {
      \ 'HTML 3.2 Final'         : 'html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN"',
      \ 'HTML 4.0 Frameset'      : 'html PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd"',
      \ 'HTML 4.0 Transitional'  : 'html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd"',
      \ 'HTML 4.0'               : 'html PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd"',
      \ 'HTML 4.01 Frameset'     : 'html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd"',
      \ 'HTML 4.01 Transitional' : 'html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"',
      \ 'HTML 4.01'              : 'html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"',
      \ 'HTML 5'                 : 'HTML',
      \ 'XHTML 1.0 Frameset'     : 'html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd"',
      \ 'XHTML 1.0 Strict'       : 'html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"',
      \ 'XHTML 1.0 Transitional' : 'html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"',
      \ 'XHTML 1.1'              : 'html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"',
      \ 'XHTML Basic 1.0'        : 'html PUBLIC "-//W3C//DTD XHTML Basic 1.0//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd"',
      \ 'XHTML Basic 1.1'        : 'html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd"',
      \ 'XHTML Mobile 1.0'       : 'html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd"',
      \ 'XHTML Mobile 1.1'       : 'html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.1//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile11.dtd"',
      \ 'XHTML Mobile 1.2'       : 'html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd"',
      \}


let s:jslib = {
            \ 'jQuery 2.0.3':'//ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js',
            \ 'jQuery 2.0.2':'//ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js',
            \ 'jQuery 2.0.1':'//ajax.googleapis.com/ajax/libs/jquery/2.0.1/jquery.min.js',
            \ 'jQuery 2.0.0':'//ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js',
            \ 'jQuery 1.10.2':'//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js',
            \ 'jQuery 1.10.1':'//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.min.js',
            \ 'jQuery 1.10.0':'//ajax.googleapis.com/ajax/libs/jquery/1.10.0/jquery.min.js',
            \ 'jQuery 1.9.1':'//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js',
            \ 'jQuery 1.9.0':'//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js',
            \ 'jQuery 1.8.3':'//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js',
            \ 'jQuery 1.8.2':'//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js',
            \ 'jQuery 1.8.1':'//ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js',
            \ 'jQuery 1.8.0':'//ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js',
            \ 'jQuery 1.7.2':'//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js',
            \ 'jQuery 1.7.1':'//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js',
            \ 'jQuery 1.7.0':'//ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js',
            \ 'jQuery 1.6.4':'//ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js',
            \ 'jQuery 1.6.3':'//ajax.googleapis.com/ajax/libs/jquery/1.6.3/jquery.min.js',
            \ 'jQuery 1.6.2':'//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js',
            \ 'jQuery 1.6.1':'//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js',
            \ 'jQuery 1.6.0':'//ajax.googleapis.com/ajax/libs/jquery/1.6.0/jquery.min.js',
            \ 'jQuery 1.5.2':'//ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js',
            \ 'jQuery 1.5.1':'//ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js',
            \ 'jQuery 1.5.0':'//ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js',
            \ 'jQuery 1.4.4':'//ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js',
            \ 'jQuery 1.4.3':'//ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js',
            \ 'jQuery 1.4.2':'//ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js',
            \ 'jQuery 1.4.1':'//ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js',
            \ 'jQuery 1.4.0':'//ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.min.js',
            \ 'jQuery 1.3.2':'//ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js',
            \ 'jQuery 1.3.1':'//ajax.googleapis.com/ajax/libs/jquery/1.3.1/jquery.min.js',
            \ 'jQuery 1.3.0':'//ajax.googleapis.com/ajax/libs/jquery/1.3.0/jquery.min.js',
            \ 'jQuery 1.2.6':'//ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js',
            \ 'jQuery 1.2.3':'//ajax.googleapis.com/ajax/libs/jquery/1.2.3/jquery.min.js',
            \ 'AngularJS 1.2.8':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.8/angular.min.js',
            \ 'AngularJS 1.2.7':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.7/angular.min.js',
            \ 'AngularJS 1.2.6':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.6/angular.min.js',
            \ 'AngularJS 1.2.5':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.5/angular.min.js',
            \ 'AngularJS 1.2.4':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.4/angular.min.js',
            \ 'AngularJS 1.2.3':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.3/angular.min.js',
            \ 'AngularJS 1.2.2':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.2/angular.min.js',
            \ 'AngularJS 1.2.1':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.1/angular.min.js',
            \ 'AngularJS 1.2.0':'//ajax.googleapis.com/ajax/libs/angularjs/1.2.0/angular.min.js',
            \ 'AngularJS 1.0.8':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.8/angular.min.js',
            \ 'AngularJS 1.0.7':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js',
            \ 'AngularJS 1.0.6':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.6/angular.min.js',
            \ 'AngularJS 1.0.5':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.5/angular.min.js',
            \ 'AngularJS 1.0.4':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js',
            \ 'AngularJS 1.0.3':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.3/angular.min.js',
            \ 'AngularJS 1.0.2':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.2/angular.min.js',
            \ 'AngularJS 1.0.1':'//ajax.googleapis.com/ajax/libs/angularjs/1.0.1/angular.min.js',
            \ 'Chrome Frame 1.0.3':'//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js',
            \ 'Chrome Frame 1.0.2':'//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.2/CFInstall.min.js',
            \ 'Chrome Frame 1.0.1':'//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.1/CFInstall.min.js',
            \ 'Chrome Frame 1.0.0':'//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.0/CFInstall.min.js',
            \ 'Dojo 1.9.2':'//ajax.googleapis.com/ajax/libs/dojo/1.9.2/dojo/dojo.js',
            \ 'Dojo 1.9.1':'//ajax.googleapis.com/ajax/libs/dojo/1.9.1/dojo/dojo.js',
            \ 'Dojo 1.9.0':'//ajax.googleapis.com/ajax/libs/dojo/1.9.0/dojo/dojo.js',
            \ 'Dojo 1.8.5':'//ajax.googleapis.com/ajax/libs/dojo/1.8.5/dojo/dojo.js',
            \ 'Dojo 1.8.4':'//ajax.googleapis.com/ajax/libs/dojo/1.8.4/dojo/dojo.js',
            \ 'Dojo 1.8.3':'//ajax.googleapis.com/ajax/libs/dojo/1.8.3/dojo/dojo.js',
            \ 'Dojo 1.8.2':'//ajax.googleapis.com/ajax/libs/dojo/1.8.2/dojo/dojo.js',
            \ 'Dojo 1.8.1':'//ajax.googleapis.com/ajax/libs/dojo/1.8.1/dojo/dojo.js',
            \ 'Dojo 1.8.0':'//ajax.googleapis.com/ajax/libs/dojo/1.8.0/dojo/dojo.js',
            \ 'Dojo 1.7.5':'//ajax.googleapis.com/ajax/libs/dojo/1.7.5/dojo/dojo.js',
            \ 'Dojo 1.7.4':'//ajax.googleapis.com/ajax/libs/dojo/1.7.4/dojo/dojo.js',
            \ 'Dojo 1.7.3':'//ajax.googleapis.com/ajax/libs/dojo/1.7.3/dojo/dojo.js',
            \ 'Dojo 1.7.2':'//ajax.googleapis.com/ajax/libs/dojo/1.7.2/dojo/dojo.js',
            \ 'Dojo 1.7.1':'//ajax.googleapis.com/ajax/libs/dojo/1.7.1/dojo/dojo.js',
            \ 'Dojo 1.7.0':'//ajax.googleapis.com/ajax/libs/dojo/1.7.0/dojo/dojo.js',
            \ 'Dojo 1.6.2':'//ajax.googleapis.com/ajax/libs/dojo/1.6.2/dojo/dojo.js',
            \ 'Dojo 1.6.1':'//ajax.googleapis.com/ajax/libs/dojo/1.6.1/dojo/dojo.js',
            \ 'Dojo 1.6.0':'//ajax.googleapis.com/ajax/libs/dojo/1.6.0/dojo/dojo.js',
            \ 'Dojo 1.5.3':'//ajax.googleapis.com/ajax/libs/dojo/1.5.3/dojo/dojo.js',
            \ 'Dojo 1.5.2':'//ajax.googleapis.com/ajax/libs/dojo/1.5.2/dojo/dojo.js',
            \ 'Dojo 1.5.1':'//ajax.googleapis.com/ajax/libs/dojo/1.5.1/dojo/dojo.js',
            \ 'Dojo 1.5.0':'//ajax.googleapis.com/ajax/libs/dojo/1.5.0/dojo/dojo.js',
            \ 'Dojo 1.4.5':'//ajax.googleapis.com/ajax/libs/dojo/1.4.5/dojo/dojo.js',
            \ 'Dojo 1.4.4':'//ajax.googleapis.com/ajax/libs/dojo/1.4.4/dojo/dojo.js',
            \ 'Dojo 1.4.3':'//ajax.googleapis.com/ajax/libs/dojo/1.4.3/dojo/dojo.js',
            \ 'Dojo 1.4.1':'//ajax.googleapis.com/ajax/libs/dojo/1.4.1/dojo/dojo.js',
            \ 'Dojo 1.4.0':'//ajax.googleapis.com/ajax/libs/dojo/1.4.0/dojo/dojo.js',
            \ 'Dojo 1.3.2':'//ajax.googleapis.com/ajax/libs/dojo/1.3.2/dojo/dojo.js',
            \ 'Dojo 1.3.1':'//ajax.googleapis.com/ajax/libs/dojo/1.3.1/dojo/dojo.js',
            \ 'Dojo 1.3.0':'//ajax.googleapis.com/ajax/libs/dojo/1.3.0/dojo/dojo.js',
            \ 'Dojo 1.2.3':'//ajax.googleapis.com/ajax/libs/dojo/1.2.3/dojo/dojo.js',
            \ 'Dojo 1.2.0':'//ajax.googleapis.com/ajax/libs/dojo/1.2.0/dojo/dojo.js',
            \ 'Dojo 1.1.1':'//ajax.googleapis.com/ajax/libs/dojo/1.1.1/dojo/dojo.js',
            \ 'Ext Core 3.1.0':'//ajax.googleapis.com/ajax/libs/ext-core/3.1.0/ext-core.js',
            \ 'Ext Core 3.0.0':'//ajax.googleapis.com/ajax/libs/ext-core/3.0.0/ext-core.js',
            \ 'jQuery UI 1.10.3':'//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jqueryui.min.js',
            \ 'jQuery UI 1.10.2':'//ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jqueryui.min.js',
            \ 'jQuery UI 1.10.1':'//ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jqueryui.min.js',
            \ 'jQuery UI 1.10.0':'//ajax.googleapis.com/ajax/libs/jqueryui/1.10.0/jqueryui.min.js',
            \ 'jQuery UI 1.9.2':'//ajax.googleapis.com/ajax/libs/jqueryui/1.9.2/jqueryui.min.js',
            \ 'jQuery UI 1.9.1':'//ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jqueryui.min.js',
            \ 'jQuery UI 1.9.0':'//ajax.googleapis.com/ajax/libs/jqueryui/1.9.0/jqueryui.min.js',
            \ 'jQuery UI 1.8.24':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.24/jqueryui.min.js',
            \ 'jQuery UI 1.8.23':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jqueryui.min.js',
            \ 'jQuery UI 1.8.22':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.22/jqueryui.min.js',
            \ 'jQuery UI 1.8.21':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.21/jqueryui.min.js',
            \ 'jQuery UI 1.8.20':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.20/jqueryui.min.js',
            \ 'jQuery UI 1.8.19':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.19/jqueryui.min.js',
            \ 'jQuery UI 1.8.18':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jqueryui.min.js',
            \ 'jQuery UI 1.8.17':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.17/jqueryui.min.js',
            \ 'jQuery UI 1.8.16':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jqueryui.min.js',
            \ 'jQuery UI 1.8.15':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.15/jqueryui.min.js',
            \ 'jQuery UI 1.8.14':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.14/jqueryui.min.js',
            \ 'jQuery UI 1.8.13':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jqueryui.min.js',
            \ 'jQuery UI 1.8.12':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/jqueryui.min.js',
            \ 'jQuery UI 1.8.11':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/jqueryui.min.js',
            \ 'jQuery UI 1.8.10':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.10/jqueryui.min.js',
            \ 'jQuery UI 1.8.9':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jqueryui.min.js',
            \ 'jQuery UI 1.8.8':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jqueryui.min.js',
            \ 'jQuery UI 1.8.7':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.7/jqueryui.min.js',
            \ 'jQuery UI 1.8.6':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jqueryui.min.js',
            \ 'jQuery UI 1.8.5':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jqueryui.min.js',
            \ 'jQuery UI 1.8.4':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jqueryui.min.js',
            \ 'jQuery UI 1.8.2':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/jqueryui.min.js',
            \ 'jQuery UI 1.8.1':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jqueryui.min.js',
            \ 'jQuery UI 1.8.0':'//ajax.googleapis.com/ajax/libs/jqueryui/1.8.0/jqueryui.min.js',
            \ 'jQuery UI 1.7.3':'//ajax.googleapis.com/ajax/libs/jqueryui/1.7.3/jqueryui.min.js',
            \ 'jQuery UI 1.7.2':'//ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jqueryui.min.js',
            \ 'jQuery UI 1.7.1':'//ajax.googleapis.com/ajax/libs/jqueryui/1.7.1/jqueryui.min.js',
            \ 'jQuery UI 1.7.0':'//ajax.googleapis.com/ajax/libs/jqueryui/1.7.0/jqueryui.min.js',
            \ 'jQuery UI 1.6.0':'//ajax.googleapis.com/ajax/libs/jqueryui/1.6.0/jqueryui.min.js',
            \ 'jQuery UI 1.5.3':'//ajax.googleapis.com/ajax/libs/jqueryui/1.5.3/jqueryui.min.js',
            \ 'jQuery UI 1.5.2':'//ajax.googleapis.com/ajax/libs/jqueryui/1.5.2/jqueryui.min.js',
            \ 'MooTools 1.4.5':'//ajax.googleapis.com/ajax/libs/mootools/1.4.5/mootools-yui-compressed.js',
            \ 'MooTools 1.4.4':'//ajax.googleapis.com/ajax/libs/mootools/1.4.4/mootools-yui-compressed.js',
            \ 'MooTools 1.4.3':'//ajax.googleapis.com/ajax/libs/mootools/1.4.3/mootools-yui-compressed.js',
            \ 'MooTools 1.4.2':'//ajax.googleapis.com/ajax/libs/mootools/1.4.2/mootools-yui-compressed.js',
            \ 'MooTools 1.4.1':'//ajax.googleapis.com/ajax/libs/mootools/1.4.1/mootools-yui-compressed.js',
            \ 'MooTools 1.4.0':'//ajax.googleapis.com/ajax/libs/mootools/1.4.0/mootools-yui-compressed.js',
            \ 'MooTools 1.3.2':'//ajax.googleapis.com/ajax/libs/mootools/1.3.2/mootools-yui-compressed.js',
            \ 'MooTools 1.3.1':'//ajax.googleapis.com/ajax/libs/mootools/1.3.1/mootools-yui-compressed.js',
            \ 'MooTools 1.3.0':'//ajax.googleapis.com/ajax/libs/mootools/1.3.0/mootools-yui-compressed.js',
            \ 'MooTools 1.2.5':'//ajax.googleapis.com/ajax/libs/mootools/1.2.5/mootools-yui-compressed.js',
            \ 'MooTools 1.2.4':'//ajax.googleapis.com/ajax/libs/mootools/1.2.4/mootools-yui-compressed.js',
            \ 'MooTools 1.2.3':'//ajax.googleapis.com/ajax/libs/mootools/1.2.3/mootools-yui-compressed.js',
            \ 'MooTools 1.2.2':'//ajax.googleapis.com/ajax/libs/mootools/1.2.2/mootools-yui-compressed.js',
            \ 'MooTools 1.2.1':'//ajax.googleapis.com/ajax/libs/mootools/1.2.1/mootools-yui-compressed.js',
            \ 'MooTools 1.1.2':'//ajax.googleapis.com/ajax/libs/mootools/1.1.2/mootools-yui-compressed.js',
            \ 'MooTools 1.1.1':'//ajax.googleapis.com/ajax/libs/mootools/1.1.1/mootools-yui-compressed.js',
            \ 'Prototype 1.7.1.0':'//ajax.googleapis.com/ajax/libs/prototype/1.7.1.0/prototype.js',
            \ 'Prototype 1.7.0.0':'//ajax.googleapis.com/ajax/libs/prototype/1.7.0.0/prototype.js',
            \ 'Prototype 1.6.1.0':'//ajax.googleapis.com/ajax/libs/prototype/1.6.1.0/prototype.js',
            \ 'Prototype 1.6.0.3':'//ajax.googleapis.com/ajax/libs/prototype/1.6.0.3/prototype.js',
            \ 'Prototype 1.6.0.2':'//ajax.googleapis.com/ajax/libs/prototype/1.6.0.2/prototype.js',
            \ 'script.aculo.us 1.9.0':'//ajax.googleapis.com/ajax/libs/scriptaculous/1.9.0/scriptaculous.js',
            \ 'script.aculo.us 1.8.3':'//ajax.googleapis.com/ajax/libs/scriptaculous/1.8.3/scriptaculous.js',
            \ 'script.aculo.us 1.8.2':'//ajax.googleapis.com/ajax/libs/scriptaculous/1.8.2/scriptaculous.js',
            \ 'script.aculo.us 1.8.1':'//ajax.googleapis.com/ajax/libs/scriptaculous/1.8.1/scriptaculous.js',
            \ 'SWFObject 2.2':'//ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js',
            \ 'SWFObject 2.1':'//ajax.googleapis.com/ajax/libs/swfobject/2.1/swfobject.js',
            \ 'Web Font Loader 1.5.0':'//ajax.googleapis.com/ajax/libs/webfont/1.5.0/webfont.js',
            \ 'Web Font Loader 1.4.10':'//ajax.googleapis.com/ajax/libs/webfont/1.4.10/webfont.js',
            \ 'Web Font Loader 1.4.8':'//ajax.googleapis.com/ajax/libs/webfont/1.4.8/webfont.js',
            \ 'Web Font Loader 1.4.7':'//ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js',
            \ 'Web Font Loader 1.4.6':'//ajax.googleapis.com/ajax/libs/webfont/1.4.6/webfont.js',
            \ 'Web Font Loader 1.4.2':'//ajax.googleapis.com/ajax/libs/webfont/1.4.2/webfont.js',
            \ 'Web Font Loader 1.3.0':'//ajax.googleapis.com/ajax/libs/webfont/1.3.0/webfont.js',
            \ 'Web Font Loader 1.1.2':'//ajax.googleapis.com/ajax/libs/webfont/1.1.2/webfont.js',
            \ 'Web Font Loader 1.1.1':'//ajax.googleapis.com/ajax/libs/webfont/1.1.1/webfont.js',
            \ 'Web Font Loader 1.1.0':'//ajax.googleapis.com/ajax/libs/webfont/1.1.0/webfont.js',
            \ 'Web Font Loader 1.0.31':'//ajax.googleapis.com/ajax/libs/webfont/1.0.31/webfont.js',
            \ 'Web Font Loader 1.0.30':'//ajax.googleapis.com/ajax/libs/webfont/1.0.30/webfont.js',
            \ 'Web Font Loader 1.0.29':'//ajax.googleapis.com/ajax/libs/webfont/1.0.29/webfont.js',
            \ 'Web Font Loader 1.0.28':'//ajax.googleapis.com/ajax/libs/webfont/1.0.28/webfont.js',
            \ 'Web Font Loader 1.0.27':'//ajax.googleapis.com/ajax/libs/webfont/1.0.27/webfont.js',
            \ 'Web Font Loader 1.0.26':'//ajax.googleapis.com/ajax/libs/webfont/1.0.26/webfont.js',
            \ 'Web Font Loader 1.0.25':'//ajax.googleapis.com/ajax/libs/webfont/1.0.25/webfont.js',
            \ 'Web Font Loader 1.0.24':'//ajax.googleapis.com/ajax/libs/webfont/1.0.24/webfont.js',
            \ 'Web Font Loader 1.0.23':'//ajax.googleapis.com/ajax/libs/webfont/1.0.23/webfont.js',
            \ 'Web Font Loader 1.0.22':'//ajax.googleapis.com/ajax/libs/webfont/1.0.22/webfont.js',
            \ 'Web Font Loader 1.0.21':'//ajax.googleapis.com/ajax/libs/webfont/1.0.21/webfont.js',
            \ 'Web Font Loader 1.0.19':'//ajax.googleapis.com/ajax/libs/webfont/1.0.19/webfont.js',
            \ 'Web Font Loader 1.0.18':'//ajax.googleapis.com/ajax/libs/webfont/1.0.18/webfont.js',
            \ 'Web Font Loader 1.0.17':'//ajax.googleapis.com/ajax/libs/webfont/1.0.17/webfont.js',
            \ 'Web Font Loader 1.0.16':'//ajax.googleapis.com/ajax/libs/webfont/1.0.16/webfont.js',
            \ 'Web Font Loader 1.0.15':'//ajax.googleapis.com/ajax/libs/webfont/1.0.15/webfont.js',
            \ 'Web Font Loader 1.0.14':'//ajax.googleapis.com/ajax/libs/webfont/1.0.14/webfont.js',
            \ 'Web Font Loader 1.0.13':'//ajax.googleapis.com/ajax/libs/webfont/1.0.13/webfont.js',
            \ 'Web Font Loader 1.0.12':'//ajax.googleapis.com/ajax/libs/webfont/1.0.12/webfont.js',
            \ 'Web Font Loader 1.0.11':'//ajax.googleapis.com/ajax/libs/webfont/1.0.11/webfont.js',
            \ 'Web Font Loader 1.0.10':'//ajax.googleapis.com/ajax/libs/webfont/1.0.10/webfont.js',
            \ 'Web Font Loader 1.0.9':'//ajax.googleapis.com/ajax/libs/webfont/1.0.9/webfont.js',
            \ 'Web Font Loader 1.0.6':'//ajax.googleapis.com/ajax/libs/webfont/1.0.6/webfont.js',
            \ 'Web Font Loader 1.0.5':'//ajax.googleapis.com/ajax/libs/webfont/1.0.5/webfont.js',
            \ 'Web Font Loader 1.0.4':'//ajax.googleapis.com/ajax/libs/webfont/1.0.4/webfont.js',
            \ 'Web Font Loader 1.0.3':'//ajax.googleapis.com/ajax/libs/webfont/1.0.3/webfont.js',
            \ 'Web Font Loader 1.0.2':'//ajax.googleapis.com/ajax/libs/webfont/1.0.2/webfont.js',
            \ 'Web Font Loader 1.0.1':'//ajax.googleapis.com/ajax/libs/webfont/1.0.1/webfont.js',
            \ 'Web Font Loader 1.0.0':'//ajax.googleapis.com/ajax/libs/webfont/1.0.0/webfont.js',
     \}


fun! s:f.js_lib_list()
    return keys( s:jslib )
endfunction

fun! s:f.js_lib_post(v)
    if has_key( s:jslib, a:v )
        return s:jslib[ a:v ]
    else
        return ''
    endif
endfunction

fun! s:f.html_doctype_list()
    return keys( s:doctypes )
endfunction

fun! s:f.html_doctype_post(v)
    if has_key( s:doctypes, a:v )
        return s:doctypes[ a:v ]
    else
        return ''
    endif
endfunction

fun! s:f.html_enc()
    return &fenc == '' ? &encoding : &fenc
endfunction

let s:nIndent = 0
fun! s:f.html_cont_ontype()
    let v = self.V()
    if v =~ '\V\n'
        let v = matchstr( v, '\V\.\*\ze\n' )
        let s:nIndent = &indentexpr != ''
              \ ? eval( substitute( &indentexpr, '\Vv:lnum', 'line(".")', '' ) ) - indent( line( "." ) - 1 )
              \ : self.NIndent()

        return self.Finish( v . "\n" . repeat( ' ', s:nIndent ) )
    else
        return v
    endif
endfunction

fun! s:f.html_cont_helper()
    let v = self.V()
    if v =~ '\V\n'
        return self.ResetIndent( -s:nIndent, "\n" )
    else
        return ''
    endif
endfunction


fun! s:f.html_tag_cmpl()
    if !exists( 'b:xpt_html_tags' )
        call htmlcomplete#LoadData()
        let tagnames = sort( keys( b:html_omni ) )
        let b:xpt_html_tags = []
        let dict = {
              \        'vimxmlattrinfo' : 1,
              \        'vimxmlentities' : 1,
              \        'vimxmlroot'     : 1,
              \        'vimxmltaginfo'  : 1,
              \        }
        for t in tagnames
            if !has_key( dict, t )
                call add(b:xpt_html_tags, t)
            endif
        endfor
    endif

    return b:xpt_html_tags

endfunction

fun! s:f.html_close_tag()
    let v = self.V()
    if v =~ '\v/\s*$|^!'
        return ''
    else
        return '</' . matchstr( v, '\v^\S+' ) . '>'
    endif
endfunction

" ================================= Snippets ===================================


call XPTdefineSnippet("id", {'syn' : 'tag'}, 'id="`^"')
call XPTdefineSnippet("class", {'syn' : 'tag'}, 'class="`^"')



" TODO map < to tag


XPT tag hidden " <$_xSnipName>..</$_xSnipName>
XSET content|def=Echo( R( 't' ) =~ '\v/\s*$' ? Finish() : '' )
XSET content|ontype=html_cont_ontype()
<`t^$_xSnipName^>`content^`content^html_cont_helper()^`t^html_close_tag()^
..XPT


XPT _tag wrap=content hidden " <$_xSnipName >..</$_xSnipName>
XSET content|ontype=html_cont_ontype()
<`$_xSnipName^>`content^^`content^html_cont_helper()^</`$_xSnipName^>
..XPT

" XPT _t hidden " ..
" <`$_xSnipName^>`cont^</`$_xSnipName^>


XPT _tagAttr wrap=content hidden " <$_xSnipName >..</$_xSnipName>
XSET content|ontype=html_cont_ontype()
XSET att?=Echo('')
XSET att?|post=Echo(V()=~'\V\^ \$\|att?' ? '' : V())
<`$_xSnipName^` `att?^>`content^^`content^html_cont_helper()^</`$_xSnipName^>
..XPT


XPT _tagblock hidden " <$_xSnipName >\n .. \n</$_xSnipName>
<`$_xSnipName^>
    `cursor^^
</`$_xSnipName^>


XPT _tagblockAttr hidden " <$_xSnipName >\n .. \n</$_xSnipName>
<`$_xSnipName^` `attr^>
    `cursor^^
</`$_xSnipName^>


XPT _shorttag hidden " <$_xSnipName />
<`$_xSnipName^ />


XPT _shorttagAttr hidden " <$_xSnipName />
XSET att?=Echo('')
XSET att?|post=Echo(V()=~'\V\^ \$\|att?' ? '' : V())
<`$_xSnipName^` `att?^/>
..XPT


XPT doctype " <!DOCTYPE ***
XSET doctype=html_doctype_list()
XSET doctype|post=html_doctype_post( V() )
<!DOCTYPE `doctype^>


XPT html " <html><head>..<head><body>...
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    `:head:^
    <body>
        `cursor^
    </body>
</html>


XPT head " <head>..</head>
<head>
    `:contenttype:^
    `:title:^
</head>



XPT contenttype " <meta http-equiv="Content-Type" content="...
<meta http-equiv="Content-Type" content="text/html; charset=`encoding^html_enc()^"/>


XPT title " <title>..</title>
<title>`title^expand('%:t:r')^</title>


XPT style " <style>..</style>
<style type="text/css" media="screen">
    `cursor^
</style>


XPT meta " <meta ..>
<meta name="`meta_name^" content="`meta_content^" />


XPT link " <link rel=".." ..>
<link rel="`stylesheet^" type="`type^text/css^" href="`url^" />


XPT script " <script language="javascript"...
<script language="javascript" type="text/javascript">
    `cursor^
</script>
..XPT


XPT scriptsrc " <script .. src=...
<script language="javascript" type="text/javascript" src="`js^"></script>


XPT jslib " <script .. src=...
XSET js=js_lib_list()
XSET js|post=js_lib_post( V() )
<script language="javascript" type="text/javascript" src="`js^"></script>

XPT body " <body>..</body>
<body>
    `cursor^
</body>



XPT table alias=_tag
XPT tr    alias=_tag
XPT td    alias=_tag
XPT th    alias=_tag


XPT fulltable hidden " create a full table
`createTable()^


XPT a wrap " <a href...
<a href="`href^">`cursor^</a>
..XPT


XPT div alias=_tag
XPT p   alias=_tag
XPT ul  alias=_tag
XPT ol  alias=_tag
XPT li  alias=_tag



XPT br alias=_shorttag
XPT img alias=_shorttagAttr
XSET att?=Embed( 'src="`where^" alt="`alt^"' )



XPT h1 alias=_tag
XPT h2 alias=_tag
XPT h3 alias=_tag
XPT h4 alias=_tag
XPT h5 alias=_tag
XPT h6 alias=_tag

XPT iframe alias=_tagAttr
XSET att?=Embed( 'name="`name^"' )



" TODO enctype list : application/x-www-form-urlencoded
XPT form wrap " <form ..>..</form>
XSET method=ChooseStr( 'GET', 'POST' )
<form action="`action^" method="`method^" accept-charset="`html_enc()^" enctype="multipart/form-data">
    `cursor^
</form>

XPT textarea alias=_tagAttr
XSET att?=Embed( 'name="`name^"' )


XPT input alias=_shorttagAttr
XSET att?=Embed( 'type="`type^" name="`name^" value="`value^"' )
XSET type=ChooseStr( 'text', 'password', 'checkbox', 'radio', 'submit', 'reset', 'file', 'hidden', 'image', 'button' )


" TODO other optional attribute like "checked", "readonly"
XPT _input_tmpl hidden " <input type=Echo($_xSnipName[1:]) ... />
<input type="`Echo($_xSnipName[1:])^" name="`name^" value="`value^" />

XPT itext     alias=_input_tmpl
XPT ipassword alias=_input_tmpl
XPT icheckbox alias=_input_tmpl
XPT iradio    alias=_input_tmpl
XPT isubmit   alias=_input_tmpl
XPT ireset    alias=_input_tmpl
XPT ifile     alias=_input_tmpl
XPT ihidden   alias=_input_tmpl
XPT iimage    alias=_input_tmpl
XPT ibutton   alias=_input_tmpl


XPT label alias=_tagAttr
XSET att?=Embed( 'for="`which^"' )


XPT select alias=_tagAttr
XSET att?=Embed( 'name="`name^"' )


XPT option alias=_tagAttr
XSET att?=Embed( 'value="`value^"' )


XPT fieldset " <fieldset ..
<fieldset>
    <legend></legend>
    `cursor^
</fieldset>
..XPT

" XPT sdiv alias=_t

" XPT diva " tips
" `:div( { 'content' : ':a:' } ):^


" html 5
" http://dev.w3.org/html5/html4-differences/Overview.html#character-encoding

" XPT section alias=_tag
" XPT article alias=_tag
" XPT aside alias=_tag
" XPT hgroup alias=_tag
" XPT header alias=_tag
" XPT footer alias=_tag
" XPT nav alias=_tag

" XPT figure alias=_tag
" XPT figcaption alias=_tag

" XPT video alias=_tag
" XPT audio alias=_tag
" XPT source alias=_tag

" XPT embed alias=_tag

" XPT mark alias=_tag
" XPT progress alias=_tag
" XPT meter alias=_tag
" XPT time alias=_tag


" XPT canvas alias=_tag
" XPT comand alias=_tag
" XPT details alias=_tag
" XPT datalist alias=_tag

" XPT keygen alias=_tag
" XPT output alias=_tag

" XPT ruby alias=_tag

" input type=
" tel
" search
" url
" email
" datetime
" date
" month
" week
" time
" datetime-local
" number
" range
" color 



