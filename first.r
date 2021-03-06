# data read
library(dplyr)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(RColorBrewer)
library(scales)
custom_colors = c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c',
                  '#fdbf6f','#ff7f00','#cab2d6')

#library(shinydashboard)
#library(extrafont)
#library(forcats)

NA_absent = function(x) {
    if(anyNA(x)) {
    levels(x) <- c(levels(x), "Absent")
    x[is.na(x)] <- "Absent"
    x}
    else x
    }

setwd("/Users/Ravi/documents/assesssmart")
ip_data = read.csv('IP data.csv', stringsAsFactors = F, header = T)
#head(ip_data)

# ip_data %>% filter(Class == "9B") %>%
#     mutate(geom.1 = Geom.1*100/13) %>%
#     ggplot(aes(geom.1)) +
#     geom_histogram()
ip_data_1 = ip_data %>% mutate(Class = as.factor(Class)) %>%
    melt(id.vars = c("Name", "School","Class", "Section", "Gender"))


ip_metadata = read.csv('IP Metadata.csv', stringsAsFactors = F, header = T)

#head(ip_metadata)

ip_metadata_1 = mutate(ip_metadata, test_name = gsub(" ", ".", Test))

data = merge(ip_data_1, ip_metadata_1, by.x = c("variable", "School", "Class", "Section"),
             by.y = c("test_name", "School", "Class", "Section"))

# Class marks evolution

p1_data = data %>%
    mutate(per_marks = value*100/Maxm.Marks) %>%
    group_by(variable, Date, School, Class, Section, Subject) %>%
    summarise(avg_marks = mean(per_marks, na.rm = T)) %>%
    mutate(variable_1 = gsub("\\.", " ", variable),
           date_1 = as.Date(Date, "%d-%m-%Y")) %>%
    filter(date_1 > Sys.Date() - 40 & !is.na(avg_marks))
    #filter(School == "Anjali EMS", Class == "9" & Section == "A" & Subject == "Algebra")


# p1 = p1_data %>% ggplot(aes(x = date_1, y = avg_marks, group = 1)) +
#     geom_line(size = 0.4, color = "#ff7f0e") +
#     geom_point(size = 1, color = "#ff7f0e") +
#     geom_hline(yintercept = 70, linetype = "dashed", color = "blue", size = 0.4) +
#     geom_hline(yintercept = 40, linetype = "dashed", color = "red", size = 0.4) +
#     theme_minimal(base_size = 12) +
#     labs(title = "Class of 9A", subtitle = "Evolution of Average Marks", x = "Date",
#          y = "Average Marks", caption = "Last 5 Weeks") +
#     annotate("text", x = p1_data$date_1, y = p1_data$avg_marks + 4,
#              label = p1_data$variable_1, size = 3, color = "#666666") +
#     coord_cartesian(ylim = c(0, 100)) +
#     theme(plot.subtitle = element_text(color="#666666"),
#           plot.caption = element_text(color="#AAAAAA", size=7))

# class + test marks distribution    
    
p2_data = data %>%
    mutate(per_marks = value*100/Maxm.Marks) %>%
    mutate(buckets = cut(per_marks, breaks = c(0, 30, 50, 70, 90, 100), include.lowest = T,
                         labels = c("< 30 %", "> 30 %", "> 50 %", "> 70 %", "> 90 %"))) %>%
    mutate(buckets = NA_absent(buckets))
    # filter(School == "Anjali EMS" & Class == "9" & Section == "A" & Subject == "Algebra" &
    #            Chapter == "Real Numbers" & Test == "Real Numbers 3")


# p2 = p2_data %>% ggplot(aes(buckets)) +
#     geom_bar(color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
#     theme_minimal(base_size = 12) +
#     labs(title = "Class of 9A", subtitle = "Distribution of Marks in Real Numbers 3", x = "Buckets",
#          y = "Number of Students") +
#     theme(plot.subtitle = element_text(color="#666666"))


# test_data = data %>%
#     mutate(per_marks = value*100/Maxm.Marks) %>%
#     mutate(buckets = cut(per_marks, breaks = c(0, 30, 50, 70, 90, 100), include.lowest = T,
#                          labels = c("< 30 %", "> 30 %", "> 50 %", "> 70 %", "> 90 %"))) %>%
#     mutate(buckets = NA_absent(buckets)) %>%
#     filter(School == "Anjali EMS" & Class == "9" & Section == "A" & Subject == "Algebra" &
#                Chapter == "Sets" & Test == "Sets 2" & !(is.na(per_marks))) %>%
#     mutate(rank_1 = cume_dist(per_marks)) %>%
#     filter(rank_1 > 0.85 | rank_1 < 0.2) %>%
#     mutate(rank_2 = rank(per_marks))
# 
# p3 = test_data %>%
#     ggplot(aes(x = reorder(Name, rank_2), y = per_marks)) +
#     geom_bar(stat = "identity", color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
#     theme_minimal(base_size = 12) +
#     labs(title = "Class of 9A", subtitle = "Top and Bottom", y = "% Marks",
#          x = "") +
#     #coord_cartesian(xlim = c(0, 100)) +
#     coord_flip() +
#     theme(plot.subtitle = element_text(color="#666666"))
# 
# p3
# 
# test_data = data %>%
#     mutate(per_marks = value*100/Maxm.Marks) %>%
#     mutate(buckets = cut(per_marks, breaks = c(0, 30, 50, 70, 90, 100), include.lowest = T,
#                          labels = c("< 30 %", "> 30 %", "> 50 %", "> 70 %", "> 90 %"))) %>%
#     mutate(buckets = NA_absent(buckets)) %>%
#     filter(School == "Anjali EMS" & Class == "9" & Section == "A" & Subject == "Algebra" &
#                !(is.na(per_marks))) %>%
#     mutate(date_1 = as.Date(Date, "%d-%m-%Y")) %>%
#     arrange(date_1) %>%
#     group_by(Name) %>%
#     mutate(lag_per_marks = lag(per_marks)) %>%
#     mutate(evol = per_marks - lag_per_marks) %>%
#     filter(Chapter == "Real Numbers" & Test == "Real Numbers 3") %>%
#     arrange(desc(evol))
# 
# p4 = head(test_data, 9) %>%
#     ggplot() +
#     geom_segment(aes(x = 1, xend = 5, y = lag_per_marks, yend = per_marks,
#                      color = Name), size = 0.7) +
#     scale_colour_manual(values = custom_colors) +
#     theme_minimal(base_size = 12) +
#     theme(panel.grid = element_blank(), axis.text.x = element_blank()) +
#     labs(title = "Class of 9A", subtitle = "Jumpers and Slippers", x = "",
#          y = "% Marks") +
#     coord_cartesian(ylim = c(0, 100)) +
#     theme(plot.subtitle = element_text(color="#666666"))
# 
# p5 = tail(test_data, 9) %>%
#     ggplot() +
#     geom_segment(aes(x = 1, xend = 5, y = lag_per_marks, yend = per_marks, color = Name)) +
#     theme_minimal(base_size = 12) +
#     theme(panel.grid = element_blank(), axis.text.x = element_blank()) +
#     labs(title = "", subtitle = "", x = "",
#          y = "% Marks") +
#     coord_cartesian(ylim = c(0, 100)) +
#     theme(plot.subtitle = element_text(color="#666666"))
# 
# 
# grid.arrange(p4, p5, ncol = 2)

p3_data = data %>%
    filter(!is.na(value)) %>%
    group_by(School, Class, Section, Subject, Chapter) %>%
    summarise(avg_marks = mean(value*100/Maxm.Marks))
    # filter(School == "Anjali EMS", Class == "9" & Section == "A" & Subject == "Algebra")
    
# p6 = test_data %>%
#     ggplot(aes(x = Chapter, y = avg_marks)) +
#     geom_bar(stat = "identity", color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
#     theme_minimal(base_size = 12) +
#     labs(title = "Class of 9A", subtitle = "Chapter Mastery", y = "% Marks",
#          x = "") +
#     theme(plot.subtitle = element_text(color="#666666"))
    
p4_data = data %>%
    mutate(per_marks = value*100/Maxm.Marks) %>%
    group_by(variable, Date, School, Class, Section, Subject, Chapter) %>%
    summarise(avg_marks = mean(per_marks, na.rm = T)) %>%
    mutate(variable_1 = gsub("\\.", " ", variable),
           date_1 = as.Date(Date, "%d-%m-%Y")) %>%
    filter(!is.na(avg_marks))
    #filter(School == "Anjali EMS", Class == "9" & Section == "A" & Subject == "Algebra" &
               #Chapter == "Sets")

# p7 = p4_data %>%
#     ggplot(aes(x = variable_1, y = avg_marks)) +
#     geom_bar(stat = "identity", color = "#1f77b4", fill = "#1f77b4", width = 0.7) +
#     theme_minimal(base_size = 12) +
#     labs(title = "Class of 9A", subtitle = "Mastery in Sets", y = "% Marks",
#          x = "") +
#     theme(plot.subtitle = element_text(color="#666666"))
#     
# p7

save.image(file = "workspace.RData")
