<?php
if ($_SERVER["REQUEST_METHOD"] == "post") {
    // Recopila los datos del formulario
    $name = $_POST["name"];
    $email = $_POST["email"];
    $message = $_POST["message"];
    
    // Realiza validaciones (opcional)
    if (empty($name) || empty($email) || empty($message)) {
        echo "Por favor, completa todos los campos obligatorios.";
        // Puedes redirigir al usuario de vuelta al formulario con un mensaje de error si lo deseas.
        // header("Location: formulario.html?error=campos");
        exit;
    }
    
    // Procesa los datos (por ejemplo, enviar un correo electrónico)
    $destinatario = "correo_destino@example.com";
    $asunto = "Nuevo mensaje de contacto desde el formulario";
    $cuerpo = "Nombre: $name\nCorreo: $email\nMensaje:\n$message";
    
    if (mail($destinatario, $asunto, $cuerpo)) {
        // Éxito: el correo se envió correctamente
        echo "¡Gracias por contactarnos! Tu mensaje ha sido enviado.";
    } else {
        // Error: no se pudo enviar el correo
        echo "Lo sentimos, hubo un problema al enviar tu mensaje. Por favor, inténtalo de nuevo más tarde.";
    }
}
?>
