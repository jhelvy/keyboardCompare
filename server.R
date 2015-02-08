# Load libraries and data
library(dplyr)
library(ggplot2)
source('./data/colors.R')
map  = read.csv(file='./data/keyboardMap.csv', header=T)

getData = function(text, map) {
    allLetters = substring(text, seq(1,nchar(text)), seq(1,nchar(text)))
    allLetters = tolower(allLetters)
    counts = table(allLetters)
    counts = data.frame(key=names(counts), count=as.integer(counts))
    # join and filter the data
    data = map %>%
        left_join(counts) %>%
        mutate(count=ifelse(is.na(count),0,count))
    return(data)
}

getHandData = function(text, map) {
    data = getData(text, map)
    handData = data %>%
        group_by(layout, hand) %>%
        summarise(count=sum(count)) %>%
        mutate(percent=round(count/sum(count)*100, 0),
               percentText=paste(percent, '%', sep=''))
    return(handData)
}

getRowData = function(text, map) {
    data = getData(text, map)
    rowData = data %>%
        filter(row>0) %>%
        group_by(layout, row) %>%
        summarise(count=sum(count)) %>%
        mutate(percent=round(count/sum(count)*100, 0),
               percentText=paste(percent, '%', sep=''))
    return(rowData)
}

shinyServer(function(input, output) {

    # Create handPlot
    output$handPlot = renderPlot({
        if ((length(input$text) > 0) & (input$text != '')) {
        handPlot = ggplot(data=getHandData(input$text, map),
            aes(x=layout, y=percent, fill=hand, ymax=100)) +
            geom_bar(stat='identity', position='dodge') +
            geom_text(aes(label=percentText), vjust=-0.5,
                      position=position_dodge(width=1), size=4) +
            scale_y_continuous(limits=c(0, 100)) +
            theme_bw() +
            labs(x='Keyboard Layout', y='Percent',
                 title='Right/Left Hand Usage by Layout') +
            scale_fill_manual(values=c('dodgerblue', 'grey70'), name='Hand')
        print(handPlot)
        }
    })

    # Create rowPlot
    output$rowPlot = renderPlot({
        if ((length(input$text) > 0) & (input$text != '')) {
        rowPlot = ggplot(data=getRowData(input$text, map),
            aes(x=row, y=percent, fill=layout, ymax=100)) +
            geom_bar(stat='identity', position='dodge') +
            geom_text(aes(label=percentText), vjust=-0.5,
                      position=position_dodge(width=1), size=3) +
            scale_y_continuous(limits=c(0, 100)) +
            theme_bw() +
            labs(x='Keyboard Row (2 is home)', y='Percent',
                 title='Keyboard Row Usage by Layout') +
            scale_fill_manual(values=c('dodgerblue', 'lightgreen', yellow, darkred), name='Layout')
        print(rowPlot)
        }
    })

    }
)

