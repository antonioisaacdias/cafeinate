# Cafeinate

App de barra de menus para macOS que impede a tela de apagar — como o `caffeinate`, mas com um clique.

## Instalar

1. Baixe o `Cafeinate.dmg` na página de [Releases](../../releases).
2. Abra o arquivo e arraste o **Cafeinate** para a pasta **Aplicativos**.
3. Abra o app. Na primeira vez o macOS avisa que não pode verificar o desenvolvedor:
   vá em **Ajustes do Sistema → Privacidade e Segurança** e clique em **Abrir Mesmo Assim**.

Requer macOS 13 ou superior (Apple Silicon ou Intel).

## Usar

Clique no ícone da xícara na barra de menus:

- **Ligar / Desligar** — mantém a tela ligada enquanto ativo (xícara cheia).
- **Configurações…**
  - **Abrir automaticamente no login**
  - **Manter o último estado ao reiniciar** — se estava ligado, volta ligado.

## Compilar

Precisa só das Command Line Tools do Xcode (`xcode-select --install`).

```bash
./build.sh
```

Gera `Cafeinate.app` e `Cafeinate.dmg`.
