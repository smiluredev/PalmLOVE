_G.love = require("love")

-- Definindo os elementos do app
local botaoNotas = {}
local botaoMP3 = {}
local imagemFundo, imagemNotas, imagemMP3

-- Variáveis para controlar a tela
local telaAtual = "menu"

-- Conteúdo do app de notas
local textoNotas = ""
local posicaoCursor = 1
local fonte

-- Conteúdo do app MP3
local somAtual = nil
local somTocando = false
local botaoPlay = {}
local botaoStop = {}
local importedAudio = nil -- Armazena o áudio importado

-- Carregar as imagens e configurar a tela
function love.load()
    -- Carrega as imagens
    imagemFundo = love.graphics.newImage("Wallpaper/wallpaper.jpg")
    imagemNotas = love.graphics.newImage("Icons/Notes.png")
    imagemMP3 = love.graphics.newImage("Icons/Music.png") -- Ícone do app de música

    -- Define a resolução da tela e permite redimensionamento
    love.window.setMode(800, 600, {fullscreen = false, resizable = true})

    -- Configurações dos botões
    local larguraTela, alturaTela = love.graphics.getDimensions()

    -- Botão de Notas
    botaoNotas.largura = 150
    botaoNotas.altura = 150
    botaoNotas.imagem = imagemNotas
    botaoNotas.pressionado = false
    botaoNotas.x = larguraTela * 0.05
    botaoNotas.y = alturaTela * 0.05

    -- Botão de MP3
    botaoMP3.largura = 150
    botaoMP3.altura = 150
    botaoMP3.imagem = imagemMP3
    botaoMP3.pressionado = false
    botaoMP3.x = larguraTela * 0.25
    botaoMP3.y = alturaTela * 0.05

    -- Botões de controle de MP3
    botaoPlay = {x = larguraTela * 0.4, y = alturaTela * 0.8, largura = 100, altura = 50, texto = "Play"}
    botaoStop = {x = larguraTela * 0.6, y = alturaTela * 0.8, largura = 100, altura = 50, texto = "Stop"}

    -- Carrega a fonte para o app de Notas
    fonte = love.graphics.newFont(12)
    love.graphics.setFont(fonte)
end

-- Função de atualização
function love.update(dt)
    -- Atualizações podem ser colocadas aqui, se necessário
end

-- Função de desenho
function love.draw()
    local larguraTela, alturaTela = love.graphics.getDimensions()

    -- Desenha a imagem de fundo
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(imagemFundo, 0, 0, 0, larguraTela / imagemFundo:getWidth(), alturaTela / imagemFundo:getHeight())

    if telaAtual == "menu" then
        -- Botão de Notas
        desenhaBotao(botaoNotas)

        -- Botão de MP3
        desenhaBotao(botaoMP3)

    elseif telaAtual == "notas" then
        -- Área de edição de notas
        love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
        love.graphics.rectangle("fill", larguraTela * 0.05, alturaTela * 0.2, larguraTela * 0.9, alturaTela * 0.6, 10, 10)

        -- Título
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("Notes", larguraTela * 0.05 + 10, alturaTela * 0.2 + 10)

        -- Exibição do texto das notas
        love.graphics.printf(textoNotas, larguraTela * 0.05 + 10, alturaTela * 0.25, larguraTela * 0.9 - 20, "left")

        -- Botão de voltar
        desenhaBotaoVoltar()

    elseif telaAtual == "mp3" then
        -- Tocar MP3
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print("PalMusic", larguraTela * 0.05, alturaTela * 0.05)

        -- Botão Play
        desenhaBotao(botaoPlay)

        -- Botão Stop
        desenhaBotao(botaoStop)

        -- Botão de voltar
        desenhaBotaoVoltar()
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

-- Função para desenhar o botão de voltar
function desenhaBotaoVoltar()
    local larguraTela, alturaTela = love.graphics.getDimensions()
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle("fill", larguraTela * 0.8, alturaTela * 0.85, larguraTela * 0.1, alturaTela * 0.05, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Back", larguraTela * 0.81, alturaTela * 0.86)
end

-- Detecção de clique no mouse
function love.mousepressed(x, y, button)
    if button == 1 then
        if telaAtual == "menu" then
            if verificaClique(botaoNotas, x, y) then
                telaAtual = "notas"
                love.keyboard.setTextInput(true) -- Ativa a entrada de texto
            elseif verificaClique(botaoMP3, x, y) then
                telaAtual = "mp3"
            end
        elseif telaAtual == "mp3" then
            if verificaClique(botaoPlay, x, y) then
                if importedAudio then
                    importedAudio:play()
                end
            elseif verificaClique(botaoStop, x, y) then
                if importedAudio then
                    importedAudio:stop()
                end
            end
        end

        -- Botão de voltar
        local larguraTela, alturaTela = love.graphics.getDimensions()
        if x >= larguraTela * 0.8 and x <= larguraTela * 0.9 and y >= alturaTela * 0.85 and y <= alturaTela * 0.9 then
            telaAtual = "menu"
            love.keyboard.setTextInput(false) -- Desativa a entrada de texto ao sair
        end
    end
end

-- Verifica se o clique foi em um botão
function verificaClique(botao, x, y)
    return x >= botao.x and x <= botao.x + botao.largura and y >= botao.y and y <= botao.y + botao.altura
end

-- Suporte para importar MP3
function love.filedropped(file)
    local filePath = file:getFilename()
    if filePath:match("%.mp3$") then -- Verifica se é um arquivo MP3
        importedAudio = love.audio.newSource(file, "stream")
        print("MP3 imported: " .. filePath)
    else
        print("Unsupported file format!")
    end
end

-- Entrada de texto para o app de notas
function love.textinput(text)
    if telaAtual == "notas" then
        textoNotas = textoNotas .. text
    end
end

-- Detecção de tecla pressionada
function love.keypressed(key)
    if telaAtual == "notas" then
        if key == "backspace" then
            local len = #textoNotas
            if len > 0 then
                textoNotas = textoNotas:sub(1, len - 1)
            end
        elseif key == "escape" then
            telaAtual = "menu"
            love.keyboard.setTextInput(false) -- Desativa o teclado virtual
        end
    end
end