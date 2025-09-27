## Bindings/Motions 
- Typical motions for movement like `w`, `b`, `^`, `$`, etc.
- `ciS`, where  S = { w, W, s, p, t, (, ), [, ], {, }, <, >, ', ", ` }`: Change in S
- `diS`, where  S = { w, W, s, p, t, (, ), [, ], {, }, <, >, ', ", ` }`: Delete in S
- `$v%`: Jump to matching bracket 
- `gg`, `G`, `C-d`, `C-u`, `zt`, `zz`: Bottom, top, down half, up half, cursor to top, cursor to middle  
- `C-*`: Search forward for word on cursor
- `C-o`, `C-i`: Previous jump, next jump 
- `C-]`, `gD`: Declaration and again for definition, definition
- `K`: Popup definition
- `' 'fw`, `' 'fb`: Fzf in buffers, fzf for buffers
- `]d`: Next diagnostic
- `' 'ca`: Code action 
- `:vsplit`: Vertical split

### NVchad
**This repo is supposed to used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
# nvim
