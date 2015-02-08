shinyUI(fluidPage(

    align='center',

    titlePanel('Keyboard Layout Comparison'),

    fluidRow(
        column(12,
            p('This program analyzes text to compare the ease of typing that text using Qwerty, Dvorak, Workman, and Norman keyboard layouts. Input the text to be analyzed below and summary figures will automagically update to show how each keyboard layout compares.'),
            h4('Text Input'),
            tags$textarea(id='text', rows=10, 'Enter text here. The plots below will display the differences between Qwerty, Dvorak, Workman, and Norman keyboard layouts in terms of the proportions of keys pressed by the left and right hands as well as differences by keyboard rows (the "home" row is row 2). You will probably notice that Dvorak, Workman, and Norman all have better balances between left and right hands and stay on the home row much more frequently than the Qwerty layout, which is the case for typing this paragraph even!'),
            tags$style(type='text/css',
            "#text{width: 600px; height: 200px;}")
        )
    ),

    hr(),

    fluidRow(
        column(12, h4('Summary Plots'))),

    fluidRow(
        column(6, plotOutput('handPlot')),
        column(6, plotOutput('rowPlot'))
    )
))



