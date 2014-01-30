XPTemplate priority=personal mark=~^

let s:f = g:XPTfuncs()

" use snippet 'varConst' to generate contant variables
" use snippet 'varFormat' to generate formatting variables
" use snippet 'varSpaces' to generate spacing variables


XPTinclude
      \ _common/common


XPT hl " tips about what this snippet does
XSET javascript=ChooseStr( 'javascript', 'java', 'c', 'python', 'bash', 'php' )
{% highlight ~javascript^ linenos %}
~cursor^
{% endhighlight %}
