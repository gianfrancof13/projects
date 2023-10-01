//funcion de operaciones matematicas
function calculadora(num1,operador,num2){
    let resultado;
    switch (operador) //estructura control switch
      {case "+": resultado = num1 + num2;
          break;
        case "-": resultado = num1 - num2;
          break;
        case "*": resultado  = num1 * num2;
          break
        case "/": resultado = num1 / num2;
          break;
        default: resultado = "Operador inexistente"
          break
      }
  console.log(resultado)
  }
  
  num1 = parseInt(prompt("Ingrese el primer numero")); 
  operador = prompt("Ingrese un operador: +, -, *, /");
  num2 = parseInt(prompt("Ingrese el segundo numero"));
  console.log(num1,num2);
  
  calculadora (num1,operador,num2);