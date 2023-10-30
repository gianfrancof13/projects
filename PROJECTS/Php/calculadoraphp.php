<?php

function suma($a,$b){
    return $a+$b;
}
function resta($a,$b){
    return $a-$b;
}
function multiplicacion($a,$b){
    return $a*$b;
}
function division($a,$b){
    return $a/$b;
}
echo "<p>" . suma(5,6) . "</p>";
echo "<p>" . resta(5,6) . "</p>";
echo "<p>" . multiplicacion(5,6) ."</p>";
echo "<p>" . division(5,6) . "</p>";
?>