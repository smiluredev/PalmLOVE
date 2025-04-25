_G.love = require("love")

-- Definindo os elementos do app
local botaoNotas = {}
local botaoMP3 = {}
local botaoImportar = {}
local imagemFundo, imagemNotas, imagemMP3

-- Variáveis para controlar a tela
local telaAtual = "menu"

-- Conteúdo do app de notas
local textoNotas = ""
local fonte

-- Conteúdo do app MP3
local sons = {} -- Armazena os sons carregados
local listaDeMusicas = {}

-- Carregar as imagens e configurar a tela
function love.load()
    -- Carrega as imagens
    imagemFundo = love.graphics.newImage("Wallpaper/wallpaper.jpg")
    imagemNotas = love.graphics.newImage("Icons/Notes.png")
    imagemMP3 = love.graphics.newImage("Icons/Music.png")

    -- Define a resolução da tela e permite redimensionamento
    love.window.setMode(800, 600, {fullscreen = false, resizable = true})

    -- Configurações dos botões
    local larguraTela, alturaTela = love.graphics.getDimensions()

    -- Botão de Notas
    botaoNotas = {
        largura = 150,
        altura = 150,
        imagem = imagemNotas,
        x = larguraTela * 0.05,
        y = alturaTela * 0.05
    }

    -- Botão de MP3
    botaoMP3 = {
        largura = 150,
        altura = 150,
        imagem = imagemMP3,
        x = larguraTela * 0.25,
        y = alturaTela * 0.05
    }

    -- Botões de controle de MP3
    botaoPlay = {
        x = larguraTela * 0.4,
        y = alturaTela * 0.8,
        largura = 100,
        altura = 50,
        texto = "Play"
    }
    botaoStop = {
        x = larguraTela * 0.6,
        y = alturaTela * 0.8,
        largura = 100,
        altura = 50,
        texto = "Stop"
    }

    -- Botão de Importar MP3
    botaoImportar = {
        x = larguraTela * 0.4,
        y = alturaTela * 0.7,
        largura = larguraTela * 0.2,
        altura = alturaTela * 0.08,
        texto = "Importar MP3"
    }

    -- Carrega a fonte para o app de Notas
    fonte = love.graphics.newFont(12)
    love.graphics.setFont(fonte)

    -- Carrega os arquivos na pasta 'music' e os adiciona ao player
    local musicas = love.filesystem.getDirectoryItems("music")
    for i = 1, #musicas, 1 do
        if musicas[i]:match("%.mp3$") then -- Verifica se o arquivo é MP3
            table.insert(listaDeMusicas, musicas[i]) -- Adiciona o nome à lista
            table.insert(sons, love.audio.newSource("music/" .. musicas[i], "stream")) -- Cria o áudio
        end
    end
end

-- Função de atualização
function love.update(dt)
end

-- Função de desenho
function love.draw()
    local larguraTela, alturaTela = love.graphics.getDimensions()

    -- Desenha a imagem de fundo
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(imagemFundo, 0, 0, 0, larguraTela / imagemFundo:getWidth(), alturaTela / imagemFundo:getHeight())

    if telaAtual == "menu" then
        desenhaBotao(botaoNotas)
        desenhaBotao(botaoMP3)

    elseif telaAtual == "mp3" then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("PalMusic", 50, 50)
        love.graphics.print("Lista de músicas:", 50, 100)

        if #listaDeMusicas > 0 then
            for i, musica in ipairs(listaDeMusicas) do
                love.graphics.print(i .. ". " .. musica, 50, 120 + (i * 20))
            end
        else
            love.graphics.print("Nenhuma música disponível.", 50, 120)
        end

        desenhaBotao(botaoPlay)
        desenhaBotao(botaoStop)
        desenhaBotao(botaoImportar)
    end
end

-- Função para desenhar botões
function desenhaBotao(botao)
    love.graphics.setColor(0.1, 0.1, 0.1, 0.6)
    love.graphics.rectangle("fill", botao.x, botao.y, botao.largura, botao.altura)
    love.graphics.setColor(1, 1, 1, 1)
    if botao.texto then
        love.graphics.printf(botao.texto, botao.x, botao.y + botao.altura / 2 - 10, botao.largura, "center")
    else
        love.graphics.draw(botao.imagem, botao.x, botao.y, 0, botao.largura / botao.imagem:getWidth(), botao.altura / botao.imagem:getHeight())
    end
end

-- Suporte para cliques
function love.mousepressed(x, y, button)
    if button == 1 then
        if telaAtual == "menu" then
            if verificaClique(botaoNotas, x, y) then
                telaAtual = "notas"
                love.keyboard.setTextInput(true)
            elseif verificaClique(botaoMP3, x, y) then
                telaAtual = "mp3" -- Altera a tela para "mp3" ao clicar no botão de MP3
            end
        elseif telaAtual == "mp3" then
            if verificaClique(botaoPlay, x, y) and #sons > 0 then
                sons[1]:play() -- Toca a primeira música
            elseif verificaClique(botaoStop, x, y) and #sons > 0 then
                sons[1]:stop() -- Para a música
            elseif verificaClique(botaoImportar, x, y) then
                local os = love.system.getOS()
                if os == "Android" then
                    print("No Android, mova os arquivos MP3 para /sdcard/Music.")
                else
                    love.system.openURL("file:///C:/Users/SeuUsuario/Music") -- Ajuste o caminho no desktop
                end
            end
        end

        -- Botão de voltar
        local larguraTela, alturaTela = love.graphics.getDimensions()
        if x >= larguraTela * 0.8 and x <= larguraTela * 0.9 and y >= alturaTela * 0.85 and y <= alturaTela * 0.9 then
            telaAtual = "menu"
            love.keyboard.setTextInput(false)
        end
    end
end

-- Verifica cliques em botões
function verificaClique(botao, x, y)
    return x >= botao.x and x <= botao.x + botao.largura and y >= botao.y and y <= botao.y + botao.altura
end