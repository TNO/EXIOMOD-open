$$
\left.
\begin{array}
a&b&c\\
d&e&f
\end{array}
\right\} test1 
$$

$$
\left.
\begin{array}
a&b&c\\
d&e&f\\
g&h&i
\end{array}
\right\} test2 
$$

<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script>
    $(document).ready(function(){
    $('.markdown-block .sqs-block-content h2').css('cursor','pointer');
    $(".markdown-block .sqs-block-content h2").nextUntil("h2").slideToggle();
    $(".markdown-block .sqs-block-content h2").click(function() {$(this).nextUntil("h2").slideToggle();});
    });
    </script>
