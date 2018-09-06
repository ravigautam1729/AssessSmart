library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)
library(gridExtra)
library(RColorBrewer)
library(scales)

load('workspace.RData')
server <- function(input, output) {
    
    
    output$evolMarks <- renderPlot({
        data_temp = p1_data %>%
            filter(School == input$school, Class == input$class &
                       Section == input$section & Subject == input$subject)
        p1 = data_temp %>% ggplot(aes(x = date_1, y = avg_marks, group = 1)) +
            geom_line(size = 0.4, color = "#ff7f0e") +
            geom_point(size = 1, color = "#ff7f0e") +
            geom_hline(yintercept = 70, linetype = "dashed", color = "blue", size = 0.4) +
            geom_hline(yintercept = 40, linetype = "dashed", color = "red", size = 0.4) +
            theme_minimal(base_size = 12) +
            labs(title = paste0("Class of ", input$class, input$section),
                 subtitle = paste0("Evolution of Average Marks in ", input$subject),
                 x = "", y = "% Average Marks", caption = "Last 5 Weeks") +
            annotate("text", x = data_temp$date_1, y = data_temp$avg_marks + 4,
                     label = data_temp$variable_1, size = 3, color = "#666666") +
            coord_cartesian(ylim = c(0, 100)) +
            theme(plot.subtitle = element_text(color="#666666"),
                  plot.caption = element_text(color="#AAAAAA", size=9))
        p1
    })
    
    output$distTestMarks <- renderPlot({
        data_temp = p2_data %>%
            filter(School == input$school1, Class == input$class1 &
                       Section == input$section1 & Subject == input$subject1 &
                       Chapter == input$theme & Test == input$tests)
        p2 = data_temp %>% ggplot(aes(buckets)) +
            geom_bar(color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
            theme_minimal(base_size = 12) +
            labs(title = paste0("Class of ", input$class1, input$section1),
                 subtitle = paste0("Distribution of Marks in ", input$tests),
                 x = "Buckets", y = "Number of Students") +
            theme(plot.subtitle = element_text(color="#666666"))
        p2
    })
    
    output$topBottom <- renderPlot({
        data_temp = p2_data %>%
            filter(School == input$school1, Class == input$class1 &
                       Section == input$section1 & Subject == input$subject1 &
                       Chapter == input$theme & Test == input$tests & !(is.na(per_marks))) %>%
            mutate(rank_1 = cume_dist(per_marks)) %>%
            filter(rank_1 > 0.85 | rank_1 < 0.2) %>%
            mutate(rank_2 = rank(per_marks))
        
        p3 = data_temp %>%
            ggplot(aes(x = reorder(Name, rank_2), y = per_marks)) +
            geom_bar(stat = "identity", color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
            theme_minimal(base_size = 12) +
            labs(title = paste0("Class of ", input$class1, input$section1),
                 subtitle = paste0("Top and Bottom in ", input$tests),
                 y = "% Marks", x = "") +
            #coord_cartesian(xlim = c(0, 100)) +
            coord_flip() +
            theme(plot.subtitle = element_text(color="#666666"))
        
        p3
    })
    
    output$jumperSlipper <- renderPlot({
        data_temp = p2_data %>%
            filter(School == input$school1 & Class == input$class1 & Section == input$section1 &
                       Subject == input$subject1 & !(is.na(per_marks))) %>%
            mutate(date_1 = as.Date(Date, "%d-%m-%Y")) %>%
            arrange(date_1) %>%
            group_by(Name) %>%
            mutate(lag_per_marks = lag(per_marks)) %>%
            mutate(evol = per_marks - lag_per_marks) %>%
            filter(Chapter == input$theme & Test == input$tests) %>%
            arrange(desc(evol))
        
        p4_1 = head(data_temp, 9) %>% filter(evol > 0) %>%
            ggplot() +
            geom_segment(aes(x = 1, xend = 5, y = lag_per_marks, yend = per_marks,
                             color = Name), size = 0.7) +
            scale_colour_manual(values = custom_colors) +
            theme_minimal(base_size = 12) +
            theme(panel.grid = element_blank(), axis.text.x = element_blank()) +
            labs(title = paste0("Class of ", input$class1, input$section1),
                 subtitle = paste0("Jumpers and Slippers in ", input$tests),
                 x = "", y = "% Marks") +
            coord_cartesian(ylim = c(0, 100)) +
            theme(plot.subtitle = element_text(color="#666666"))
        
        p4_2 = tail(data_temp, 9) %>% filter(evol < 0) %>%
            ggplot() +
            geom_segment(aes(x = 1, xend = 5, y = lag_per_marks, yend = per_marks,
                             color = Name), size = 0.7) +
            scale_colour_manual(values = custom_colors) +
            theme_minimal(base_size = 12) +
            theme(panel.grid = element_blank(), axis.text.x = element_blank()) +
            labs(title = "", subtitle = "", x = "", y = "", caption = "Since Last Test") +
            coord_cartesian(ylim = c(0, 100)) +
            theme(plot.subtitle = element_text(color="#666666"),
                  plot.caption = element_text(color="#AAAAAA", size=9))
        
        p4 = grid.arrange(p4_1, p4_2, ncol = 2)
        
        p4
        
        
    })
    
    output$chapMastery <- renderPlot({
        data_temp = p3_data %>%
            filter(School == input$school, Class == input$class &
                       Section == input$section & Subject == input$subject)
        p5 = data_temp %>%
            ggplot(aes(x = Chapter, y = avg_marks)) +
            geom_bar(stat = "identity", color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
            theme_minimal(base_size = 12) +
            labs(title = paste0("Class of ", input$class, input$section),
                 subtitle = paste0("Chapter Mastery in ", input$subject),
                 y = "% Marks", x = "") +
            coord_cartesian(ylim = c(0, 100)) +
            theme(plot.subtitle = element_text(color="#666666"))
        p5
    })
    
    output$testChapMastery <- renderPlot({
        data_temp = p4_data %>%
            filter(School == input$school2, Class == input$class2 &
                       Section == input$section2 & Subject == input$subject2 &
                       Chapter == input$theme1)
        p6 = data_temp %>%
            ggplot(aes(x = variable_1, y = avg_marks)) +
            geom_bar(stat = "identity", color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
            theme_minimal(base_size = 12) +
            labs(title = paste0("Class of ", input$class2, input$section2),
                 subtitle = paste0("Mastery in ", input$theme1), y = "% Marks",
                 x = "") +
            coord_cartesian(ylim = c(0, 100)) +
            theme(plot.subtitle = element_text(color="#666666"))
        p6
    })
    
    output$chapControl2 <- renderUI({
        data_temp = unique(p4_data %>%
            filter(School == input$school2, Class == input$class2 &
                       Section == input$section2 & Subject == input$subject2) %>%
            .$Chapter)
        selectInput("theme1", "Chapter/Theme", data_temp)
    })

    
}