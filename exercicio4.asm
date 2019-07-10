# Programa que calcula as raizes de uma equação de segundo grau
# Feito por Yuri Becker e Daniel Libanori

.text

# imprime mensagem de texto para o usuário
.macro output(%str) 			
	.data
	mensagem: .asciiz %str
	.text
	li $v0, 4
	la $a0, mensagem
	syscall
.end_macro

main:
	output("Calculadora das raizes de ax² + bx + c = 0 \n\n")
	
	output("Digite o valor de A (A!=0): ")
	li 	$v0, 7
	syscall
	mov.d  	$f10, $f0 
	
	output("Digite o valor de B: ")
	li 	$v0, 7
	syscall
	mov.d  	$f12, $f0 
	
	output("Digite o valor de C: ")
	li 	$v0, 7
	syscall
	mov.d  	$f14, $f0 			
	
	mul.d 	$f16, $f12, $f12   	# $f16 = b*b
	mul.d 	$f18, $f10, $f14	# $f18 = a*c
	li    	$t0, 4			# $t0 = 4
	mtc1 	$t0, $f20 		# $f20 = $t0
	cvt.d.w $f20, $f20		# converte de word -> double
	mul.d 	$f22, $f18, $f20	# $f22 = 4*a*c
	sub.d 	$f16, $f16, $f22	# delta = b*b - 4*a*c
	sqrt.d  $f18, $f16		# raiz de delta
	
	li    	$t0, -1			# $t0 = -1
	mtc1 	$t0, $f20 		# $f20 = $t0
	cvt.d.w $f20, $f20		# converte de word -> double
	mul.d 	$f22, $f12, $f20	# $f22 = -1 * B
	
	li    	$t0, 2			# $t0 = 2
	mtc1 	$t0, $f20 		# $f20 = $t0
	cvt.d.w $f20, $f20		# converte de word -> double
	mul.d 	$f24, $f10, $f20	# $f24 = 2 * A
	
	# Recapitulando, $f10 = A, $f12 = B, $f16 = Delta, $f18 = raiz de Delta, $f22 = -B e $f24 = 2A 
	
	mtc1   	$zero, $f0 		# $f0 = $zero
	cvt.d.w $f0, $f0		# converte de word -> double
	c.lt.d 	$f16, $f0     		# $f16 < 0 ($f0)
	bc1t 	delta_menor_que_zero 	# Pula para delta_menor_que_zero

	mtc1 	$zero, $f0 		# $f0 = $zero
	c.eq.d  $f16, $f0     		# $f16 == 0 ($f0)
	bc1t  	delta_igual_a_zero 	# Pula para delta_igual_a_zero
	
	j 	delta_maior_que_zero	# Pula para delta_maior_que_zero

	
delta_menor_que_zero:
	output("\nDelta menor que Zero, nenhuma raiz real")
	j	fim_programa
	
delta_igual_a_zero:
	output("\nDelta igual a Zero, uma única raiz real")
	j	calcula_raiz_2
	
delta_maior_que_zero:
	output("\nDelta maior que Zero, duas raízes reais")
	j 	calcula_raiz_1

calcula_raiz_1:
	add.d 	$f26, $f22, $f18 	# $f26 = -B + raiz de delta
	div.d 	$f28, $f26, $f24	# $28 = (-B + raiz de delta) / 2*A
	
	output("\nRaiz: ")
	li 	$v0, 3
	mov.d 	$f12, $f28 
	syscall				# Mostra o valor da raiz
	
calcula_raiz_2:
	sub.d 	$f26, $f22, $f18 	# $f26 = -B - raiz de delta
	div.d 	$f30, $f26, $f24	# $28 = (-B - raiz de delta) / 2*A
	
	output("\nRaiz: ")
	li 	$v0, 3
	mov.d 	$f12, $f30 
	syscall				# Mostra o valor da raiz

fim_programa:
	li      $v0, 10 		# código para fechar o programa
	syscall                         # chamada ao sistema
	
