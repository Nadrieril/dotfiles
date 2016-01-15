atom.commands.add 'atom-text-editor', 'my:move-line-up', ->
  editor = atom.workspace.getActiveTextEditor()
  if atom.config.get('editor.autoIndent')
    atom.config.set('editor.autoIndent', false)
    editor.moveLineUp()
    atom.config.set('editor.autoIndent', true)
  else
    editor.moveLineUp()

atom.commands.add 'atom-text-editor', 'my:move-line-down', ->
  editor = atom.workspace.getActiveTextEditor()
  if atom.config.get('editor.autoIndent')
    atom.config.set('editor.autoIndent', false)
    editor.moveLineDown()
    atom.config.set('editor.autoIndent', true)
  else
    editor.moveLineDown()
