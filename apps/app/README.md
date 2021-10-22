# Install
##### Contents

- [Get up and running](#get_up_and_running)
- [Managing environment variables](#manage_environment_variables)
- [Rebranding](#rebranding)
- [Setup Cloudinary](#setup_cloudinary)
- [Managing environments](#manage_environments)
- [VSCode setup](#vscode_setup)
- [Useful links](#useful_links)

<h2 id="get_up_and_running">Get up and running</h2>

[Download the boilerplate](#)

Rename folder to your project name:

```bash
mv petal my-cool-project
```

Name your database in `dev.ex`.

```elixir
# Configure your database
config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  database: "my_cool_project_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  log: false
```

Setup the project (create database, run migrations, seed the database).

```bash
mix setup
```

Download NPM packages.

```bash
cd assets && npm i && cd ..
```

Start the server (in IEX mode for a better development experience).

```bash
iex -S mix phx.server
```

<h2 id="manage_environment_variables">Managing environment variables</h2>

We recommend using [direnv](https://direnv.net) for local environment variables.

```bash
brew install direnv
```

In the root of your project copy the `.envrc.example`

```bash
cp .envrc.example .envrc
```

Modify `.envrc` to export your environment variables. Eg.

```bash
export CLOUDINARY_API_KEY="efklejflekw"
```

Anytime you change your `.envrc` file you need to run:

```bash
direnv allow
```

Once set, any time you're in your project directory the environment variables will be automatically loaded from your `.envrc` file, so you don't have to worry about them when starting your server.

<h2 id="rebranding">Rebranding</h2>

- Replace `priv/static/images/logo.png` & `logo.svg`
- Replace `priv/static/images/logo-on-dark.png` with a light version of your full logo (something that works on a dark background). Optional - only if you want to use a dark background at some point.
- Replace `priv/static/images/favicon.png` with an icon version of your logo
- Replace `priv/static/images/open-graph.png` with whatever image you want to appear on sites like Facebook when your website is shared (use same dimensions as the current image)
- Replace `priv/static/images/logo-192x192.png` with an icon version of your logo that will appear on mobile screens if they create a shortcut
- Replace `priv/static/images/logo-icon.svg` with an icon version of your logo for your authentication screens

- Open file "layout_view.ex" and replace meta variables at the top (title, description, keywords)
- Open file "manifest.json" and add in your values

<h2 id="setup_cloudinary">Setup Cloudinary</h2>

[Cloudinary](https://cloudinary.com) allows you to store, transform, optimize, and deliver all your media assets with easy-to-use APIs, widgets, or user interfaces.

Our opinion is that this is better than Amazon S3 or any other plain storage solution because it allows you to transform images simply by modifying the url.

For example, if you uploaded a portrait photo of yourself you could do this to get a nice avatar:

```
https://res.cloudinary.com/demo/image/upload/c_crop,g_face,h_400,w_400/r_max/c_scale,w_200/lady.jpg
```

* Zoom into the face
* Crop to 400x400
* Set width to 200px
* Turn image into a circle

First sign up and find your API keys. Put your environment variables into your `.envrc` file.

```bash
export CLOUDINARY_API_KEY="xxx"
export CLOUDINARY_SECRET="xxx"
export CLOUDINARY_CLOUD_NAME="xxx"
export CLOUDINARY_FOLDER="petal/dev"
export CLOUDINARY_IMAGES_UPLOAD_PRESET="petal_dev"
```

Learn how to create an upload preset [here](https://cloudinary.com/documentation/upload_presets). It should look something like this:

```
Unique filename: true
Delivery type: upload
Access mode: public
Folder: petal/dev/images
```

<h2 id="manage_environments">Managing Elixir, Erlang and Node</h2>

We recommend using [asdf](https://asdf-vm.com/) to manage your Elixir, Erlang and Node versions. It allows you to have multiple versions on your computer.

For Macs using Homebrew:

```bash
brew install coreutils curl git gnupg gnupg2
brew install asdf
echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.zshrc
```

Reload your terminal. Note that the versions for each language is defined in the file `.tool-versions`. Petal has defined versions in there already - and the following install instructions matches those versions. Feel free to update the versions if they are outdated (see "Maintenance" below).

### Install Erlang

```bash
asdf plugin add erlang
asdf install erlang 23.1
asdf global erlang 23.1
```

### Install Elixir

```bash
asdf plugin add elixir
asdf install elixir 1.10.4
asdf global elixir 1.10.4
```

### Install Node

```bash
asdf plugin add nodejs
```

Note: For Mac I had to run this command to get Node install to work properly:

```bash
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 12.18.2
asdf global nodejs 12.18.2
```

### Install hex

```bash
mix local.hex
```

### Folder structure

Since all of our surface files live in the `live` folder, it's useful to have some kind of structure.

A live view must have the word "Live" somewhere in the module name. eg:
AboutUsPage FAILS
AboutUsPageLive SUCCESS
AboutUsLive.Index SUCCESS

We use a module system:

app_web
|--live
|  |-- module_live
|  |   |-- components
|  |   |   |-- component1.ex
|  |   |   |-- component2.ex
|  |   |-- live_view1.ex
|  |   |-- live_view2.ex
|  |-- post_live
|  |   |-- components
|  |   |   |-- content.ex
|  |   |   |-- comments.ex
|  |   |   |-- form.ex
|  |   |-- show.ex <- live view
|  |   |-- index.ex <- live view
|  |   |-- edit.ex <- live view

We don't put any live views directly in the "live" folder:

/lib/live/some_live_view.ex WRONG
/lib/live/module_name/some_live_view.ex CORRECT

Routes therefore take this style: `Routes.module_live_view_path(_,_)`:

| Module                       | Folder                          | Route                           |
|------------------------------|---------------------------------|---------------------------------|
| AppWeb.PostsLive.Show        | /live/posts_live/show.ex        | Routes.posts_show_path()        |
| AppWeb.AuthLive.Passwordless | /live/auth_live/passwordless.ex | Routes.auth_passwordless_path() |


<h2 id="vscode_setup">VSCode setup</h2>

### Extensions

- [ElixirLS](https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls) - this will analyse your Elixir code and highlight errors.
- [EEx snippets](https://marketplace.visualstudio.com/items?itemName=stefanjarina.vscode-eex-snippets) - Elixir EEx and HTML (EEx) code snippets.
- [TailwindCSS](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss) - Intelligent Tailwind CSS tooling for VS Code
- [Tailwind Docs](https://marketplace.visualstudio.com/items?itemName=austenc.tailwind-docs) - Easily access the Tailwind CSS documentation from within Code
- [Headwind](https://marketplace.visualstudio.com/items?itemName=heybourn.headwind) - An opinionated class sorter for Tailwind CSS
- [Window Colors](https://marketplace.visualstudio.com/items?itemName=stuart.unique-window-colors) - Automatically adds a unique color to each window's activityBar and titleBar. Useful when you have multiple projects on the go.
- [CodeSandbox Theme](https://marketplace.visualstudio.com/items?itemName=ngryman.codesandbox-theme) - Optional. We just like this color theme.
- [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) - Material Design Icons for Visual Studio Code
- [Color Info](https://marketplace.visualstudio.com/items?itemName=bierner.color-info) - Provides quick information about css colors

### Settings

```json
{
  "workbench.colorTheme": "CodeSandbox",
  "workbench.iconTheme": "material-icon-theme",
  "terminal.integrated.fontSize": 14,
  "terminal.integrated.lineHeight": 0.8,
  "terminal.integrated.fontFamily": "Menlo",
  "workbench.fontAliasing": "auto",
  "breadcrumbs.enabled": true,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "editor.tabSize": 2,
  "editor.fontWeight": "500",
  "editor.fontFamily": "'JetBrains Mono', Menlo, 'Courier New', monospace",
  "editor.fontSize": 14,
  "editor.minimap.enabled": false,
  "editor.fontLigatures": true,
  "editor.tabCompletion": "onlySnippets",
  "editor.snippetSuggestions": "top",
  "explorer.confirmDelete": false,
  "explorer.autoReveal": false,
  "explorer.compactFolders": false,
  "explorer.confirmDragAndDrop": false,
  "[javascript]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode",
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "HookyQR.beautify"
  },
  "[html-eex]": {
    "editor.formatOnSave": false,
  },
  "[elixir]": {
    "editor.formatOnSave": true,
  },
  "emmet.includeLanguages": {
    "html-eex": "html",
    "surface": "html",
    "elixir": "html",
    "javascript": "javascriptreact"
  },
  "emmet.excludeLanguages": [
    "markdown"
  ],
  "tailwindCSS.includeLanguages": {
    "HTML (Embedded Elixir)": "html",
    "html-eex": "html",
    "surface": "html",
  },
  "tailwindCSS.emmetCompletions": true,
  "tailwindCSS.colorDecorators": "on",
  "terminal.external.osxExec": "iTerm.app",
  "terminal.integrated.shell.osx": "/bin/zsh",
  "javascript.updateImportsOnFileMove.enabled": "always",
  "files.exclude": {
    "_build": true,
    ".elixir_ls": true,
    "deps": true
  },
  "elixirLS.suggestSpecs": false,
  "elixirLS.mixEnv": "dev",
  "elixirLS.fetchDeps": false,
  "beautify.language": {
    "js": [],
    "css": [],
    "html": {
      "type": [
        "htm",
        "html"
      ],
      "filename": [
        ".html.leex",
        ".html.eex",
        ".html"
      ]
    },
  },
  "search.exclude": {
    "**.package-lock.json": true
  },
  "git.confirmSync": false,
  "git.autoStash": true,
  "window.zoomLevel": 1,
}
```

<h3 id="useful_links">Useful links</h3>

- [Heroicons](https://heroicons.com/) will help with your icons. We recommend just inlining the SVG code.
- [Tailwind Play](https://play.tailwindcss.com/) - workshop new Tailwind components
- [Tailwind Ink](https://tailwind.ink/) - create color palettes for Tailwind
- Keep up to date with Phoenix using [Phoenix diff](https://www.phoenixdiff.org) or [diff.hex.pm](https://diff.hex.pm)
- Keep up to date with [phx.gen.auth diffs](https://github.com/aaronrenner/phx_gen_auth/blob/master/CHANGELOG.md)
