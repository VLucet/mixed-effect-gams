all: main example_data md fig tex 
main: example_data md fig tex 


example_data: data/bird_move.csv data/zooplankton_example.csv
				R --vanilla --slave -e "source('code/bird_example_data.R')"
				R --vanilla --slave -e "source('code/cleaning_zooplankton_data.R')"

md: paper_sections/01-intro.Rmd paper_sections/02-gams.Rmd paper_sections/03-hierarchical_gams.Rmd paper_sections/04-examples.Rmd paper_sections/05-computational_and_statistical_issues.Rmd 

fig: figures/temp_growth_example.pdf code/alternate_models.R 
				R --vanilla --slave -e "source('code/alternate_models.R')"

tex: paper_sections/bibliography.bib paper_sections/peerj.csl paper_sections/preamble.sty

main: paper_sections/full_document.Rmd
				R --vanilla --slave -e "library(knitr); purl('paper_sections/full_document.Rmd',documentation =0, output = 'compiled_paper/supplemental_code.R')"
				R --vanilla --slave -e "library(rmarkdown); render('paper_sections/full_document.Rmd',output_file = 'full_document.tex')"
				sed -i '/xcolor/d' paper_sections/full_document.tex
				R --vanilla --slave -e "setwd('paper_sections'); library(tools); texi2pdf('full_document.tex',clean = TRUE)"
				mv paper_sections/full_document.pdf compiled_paper/full_document.pdf 
				mv paper_sections/full_document.tex compiled_paper/full_document.tex 

