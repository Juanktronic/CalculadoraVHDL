Este proyecto contiene código realizado para la asignatura de Diseño de Sistemas Digitales en la Pontificia Universidad Javeriana. 
Consiste en una calculadora realizada en VHDL para funcionar en la tarjeta FPGA terasic DE0.

Las especificaciones a cumplir son las siguientes:

 La calculadora debe implementar suma, resta y multiplicación para números binarios de 4-bits.
 Los operandos y el tipo de operación deben ser introducidos al sistema por el usuario utilizando los interruptores de
la tarjeta Terasic DE0.
 Tanto los valores de los operandos como el resultado de la operación deben ser visualizados utilizando los displays 7-
segmentos disponibles en la tarjeta Terasic DE0.
 Detección de error: Aunque el rango de visualización posible en un display 7-segmentos puede llegar a ser de 0 (0b0000
– 0x0) a 15 (0d1111 - 0xF), en general no se espera que los usuarios tengan conocimientos de codificación
hexadecimal. Por tanto, una calculadora digital deberá limitar las operaciones a números en el rango de [0,9] digitados
por el usuario en codificación BCD (binary-coded decimal), reconociendo cuando el usuario introduzca un valor en
binario superior a 9 en los operandos. En tal caso, la calculadora deberá desplegar el dígito ‘E’ en el correspondiente
display 7-segmentos, así como “EE” en el resultado de la operación, hasta tanto el usuario no introduzca un valor
válido dentro del rango permitido en los operandos.
 La implementación del sistema debe incluir:
o Redes de compuertas
o Circuitos aritméticos
o Multiplexores
o Encoders/Decoders/Coders
o En general, todos los circuitos combinacionales discutidos en el curso. 

Al final se cumplieron todas las especificaciones con un bajo número de circuitos lógicos.
