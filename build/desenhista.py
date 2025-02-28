import cv2
import matplotlib.pyplot as plt
import numpy as np


def ler_mapa(image_path):
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    mapa = (img == 0).astype(np.uint8)
    return mapa


def encontrar_blocos(mapa):
    largura, altura = mapa.shape
    blocos = []
    for y in range(altura):
        for x in range(largura):
            if mapa[y, x] == 1:
                blocos.append((x, y))
    return blocos


def encontrar_pontas(blocos):
    pontas = []
    vizinhos = [ (0, 1), (0, -1), (1, 0), (-1, 0) ]
    for bloco in blocos:
        # Verificar vizinhos
        grau = 0
        for vizinho in vizinhos:
            xv = bloco[0] + vizinho[0]
            yv = bloco[1] + vizinho[1]
            if mapa[yv, xv] == 1:
                grau += 1
        if grau == 1:
            pontas.append(bloco)
    return pontas


def encontrar_vizinhos(bloco, mapa):
    vizinhos = []
    posicoes_vizinhos = [ (0, 1), (0, -1), (1, 0), (-1, 0) ]
    for pos_viz in posicoes_vizinhos:
        xv = bloco[0] + pos_viz[0]
        yv = bloco[1] + pos_viz[1]
        if mapa[yv, xv] == 1:
            vizinhos.append((xv, yv))
    return vizinhos


def dentro_de(bloco, mapa):
    largura, altura = mapa.shape
    return all([
            bloco[0] >= 0,
            bloco[0] < largura,
            bloco[1] >= 0,
            bloco[1] < altura
            ])


def encontrar_caminhoV0(mapa):
    caminho = []

    blocos = encontrar_blocos(mapa)
    inicio = blocos[0]
    percorridos = []

    atual = [0, 0]
    atual[0] = inicio[0]
    atual[1] = inicio[1]

    finished = False
    while not finished:
        vizinhos = encontrar_vizinhos(atual, mapa)
        # mover na direção de um vizinho que ainda não foi percorrido
        for v in vizinhos:
            if v not in percorridos:
                percorridos.append(v)
                if not dentro_de(v, mapa):
                    continue
                
                direcao = (v[0] - atual[0], v[1] - atual[1])
                if direcao[0] == 0 and direcao[1] == 1:
                    caminho.append("d")
                elif direcao[0] == 0 and direcao[1] == -1:
                    caminho.append("u")
                elif direcao[0] == 1 and direcao[1] == 0:
                    caminho.append("r")
                elif direcao[0] == -1 and direcao[1] == 0:
                    caminho.append("l")

                atual[0] = v[0]
                atual[1] = v[1]

                if atual[0] == inicio[0] and atual[1] == inicio[1]:
                    finished = True
                break
    return caminho

        




if __name__ == "__main__":
    image_path = "./imagens/triangulo.png"
    mapa = ler_mapa(image_path)
    caminho = encontrar_caminhoV0(mapa)

    print(caminho)
