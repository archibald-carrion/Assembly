/**
 *   CI0118 Lenguajes ensambladores
 *   Grupo: 02 (Francisco Arroyo)
 *   Ejemplo de llamado a rutinas en ensamblador desde C
 *
 *   Compilar: g++ -g bisTest.cc bisiesto.s -o bisTest.out
 *   Correr: ./bisTest.out
 *
 */
#include <iostream>


extern "C" int bisiesto( int );	// Declaración para indicar que esta rutina se define en "link time"
				// El símbolo "bisiesto" debe coincidir con la rutina en ensamblador y debe ser global

/**
 *
 */
int main ( int argumentos, char **valores ) {
    int resultado;
    int n = 2022;
    const char * msg [] = { " no", "" };

    if ( argumentos > 1 ) {		// Check for argument
       n = atoi( valores[ 1 ] );	// Convert argument to number
    }
    // bisiesto( n )
    //std::cout <<  bisiesto( n ) << std::endl;

    resultado = bisiesto( n );	// Call assembly routine
    if ( resultado ) {
       msg[ 0 ]  = 0;
    }

    std::cout << "El año " << n << msg[ resultado ] << " es bisiesto." << std::endl;

    return 0;
}
