#' Cogsci submission format (PDF)
#'
#' Template for creating a CogSci submission
#'
#' @inheritParams pdf_document
#'
#' @export

cogsci_paper <- function(keep_tex = TRUE,
                           includes = NULL) {

    template <- find_resource("cogsci_paper_2016", "template.tex")

    base <- rmarkdown::pdf_document(template = template,
                                    keep_tex = keep_tex,
                                    includes = includes)

    # Mostly copied from knitr::render_sweave
    base$knitr$opts_knit$out.format <- "sweave"

    base$knitr$opts_chunk$prompt <- TRUE
    base$knitr$opts_chunk$comment <- NA
    base$knitr$opts_chunk$highlight <- FALSE

    hook_chunk <- function(x, options) {
        if (knitr:::output_asis(x, options)) return(x)
        paste0('\\begin{CodeChunk}\n', x, '\\end{CodeChunk}')
    }
    hook_input <- function(x, options) {
        paste0(c('\\begin{CodeInput}', x, '\\end{CodeInput}', ''),
               collapse = '\n')
    }
    hook_output <- function(x, options) {
        paste0('\\begin{CodeOutput}\n', x, '\\end{CodeOutput}\n')
    }

    base$knitr$knit_hooks$chunk   <- hook_chunk
    base$knitr$knit_hooks$source  <- hook_input
    base$knitr$knit_hooks$output  <- hook_output
    base$knitr$knit_hooks$message <- hook_output
    base$knitr$knit_hooks$warning <- hook_output
    base$knitr$knit_hooks$plot <- knitr::hook_plot_tex # this controls the chunk options for tex

    base
}
