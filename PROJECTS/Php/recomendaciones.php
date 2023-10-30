<?php
/*Tener una lista de ciudades con un clima 
y ubicacion especifica*/

function recomendacion(){

    $clima = array(
        "Chubut" => "Frio",
        "San Luis" => "Templado",
        "Salta" => "Caliente");
    $ubicacion = array(
        "Jujuy" => "Norte",
        "Misiones" => "Este",
        "Mendoza" => "Oeste",
        "Neuquen" => "Sur");
    $turismo = array(
        "Buenos aires" => "Mar",
        "La rioja" => "Desierto",
        "Catamarca" = "Valle",
        "La pampa" => "Llano");

    switch('clima'){
        case 'clima': 
            echo array_search('Frio', $clima);
        break;
        case 'ubicacion':
            echo array_search('Norte'. $ubicacion);
        break;
        case 'turismo':
            echo array_search('Mar', $turismo);
        break;
    }

recomendacion();
}
?>