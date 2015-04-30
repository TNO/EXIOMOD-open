<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script>
    $(document).ready(function(){
    $('.markdown-block .sqs-block-content h2').css('cursor','pointer');
    $(".markdown-block .sqs-block-content h2").nextUntil("h2").slideToggle();
    $(".markdown-block .sqs-block-content h2").click(function() {$(this).nextUntil("h2").slideToggle();});
    });
    </script>

+ This is a first question
-----------------
This is the first line of an answer to the question above. This is a second line of the answer.

* Bullet points
* Can be used too

+ This is a second question
-----------------
This is a one line answer to the question above.

This is a regular paragraph.

This is another regular paragraph.

<table>
    <tr>
        <td>This is a table</td><td>This is another cell</td>
	</tr>
	<tr>
        <td>This is a third cell</td><td>This is a fourth cell</td>
	</tr>
</table>


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
