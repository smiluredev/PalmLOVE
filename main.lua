_G.love = require("love")

function love.load()
    tela_atual = "menu"
    texto = ""  -- inicializa o conteúdo digitado
end

function love.update(dt)
end

function love.draw()
    if tela_atual == "menu" then
        love.graphics.print("PalmLOVE", 100, 50)
        love.graphics.rectangle("line", 100, 100, 100, 40)
        love.graphics.print("Notes", 115, 115)

    elseif tela_atual == "Notes" then
        love.graphics.print("Notes", 20, 20)
        love.graphics.rectangle("line", 20, 50, 240, 140)
        love.graphics.print(texto, 30, 60) -- mostra o texto digitado
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if tela_atual == "menu" and x > 100 and x < 200 and y > 100 and y < 140 then
            tela_atual = "Notes"
            love.keyboard.setTextInput(true) -- chama o teclado virtual
        end
    end
end

function love.textinput(t)
    if tela_atual == "Notes" then
        texto = texto .. t
    end
end

function love.keypressed(key)
    if tela_atual == "Notes" then
        if key == "backspace" then
            local len = #texto
            if len > 0 then
                texto = texto:sub(1, len - 1)
            end
        elseif key == "escape" or key == "return" then
            -- Sai da tela de notas
            tela_atual = "menu"
            love.keyboard.setTextInput(false) -- esconde o teclado
        end
    end
end