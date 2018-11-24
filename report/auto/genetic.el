(TeX-add-style-hook
 "genetic"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("report" "12pt")))
   (TeX-run-style-hooks
    "latex2e"
    "report"
    "rep12"
    "graphicx"))
 :latex)

