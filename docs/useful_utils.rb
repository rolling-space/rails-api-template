def red(text)
  "\033[31m#{text}\033[0m"
end

def red_bold(text)
  "\033[31;1m#{text}\033[0m"
end

def tty_required_message
  puts red_bold('┌────────────────────────────────────────────────────┐')
  puts red_bold('│ TEMPLATE ERROR:                                    │')
  puts      red('│ tty-prompt is required to use this template - run: │')
  puts red_bold('│ gem install tty-prompt                             │')
  puts      red('│ and try again afer installation finishes           │')
  puts      red('│ https://github.com/piotrmurach/tty-prompt          │')
  puts red_bold('└────────────────────────────────────────────────────┘ ')
end
