<!DOCTYPE style-sheet PUBLIC "-//James Clark//DTD DSSSL Style Sheet//EN" [
]>

<style-sheet>


<style-specification>
<style-specification-body> 
(declare-flow-object-class element
  "UNREGISTERED::James Clark//Flow Object Class::element")
(declare-flow-object-class empty-element
  "UNREGISTERED::James Clark//Flow Object Class::empty-element")
(declare-characteristic preserve-sdata?
  "UNREGISTERED::James Clark//Characteristic::preserve-sdata?" #t)

<!--
(declare-flow-object-class document-type
  "UNREGISTERED::James Clark//Flow Object Class::document-type")

(declare-flow-object-class processing-instruction
  "UNREGISTERED::James Clark//Flow Object Class::processing-instruction")

(declare-flow-object-class entity
  "UNREGISTERED::James Clark//Flow Object Class::entity")

(declare-flow-object-class entity-ref
  "UNREGISTERED::James Clark//Flow Object Class::entity-ref")

(declare-flow-object-class formatting-instruction
  "UNREGISTERED::James Clark//Flow Object Class::formatting-instruction")

(define debug
  (external-procedure "UNREGISTERED::James Clark//Procedure::debug"))

(define read-entity
  (external-procedure "UNREGISTERED::James Clark//Procedure::read-entity"))

(define all-element-number
  (external-procedure "UNREGISTERED::James Clark//Procedure::all-element-number"))
-->

(define newline (literal "\carriage-return" "\line-feed"))

(element itemizedlist 
  (make scroll
    (make element
      gi: "ul"
      (process-children-trim))
    newline))
(element listitem
  (make scroll
    (make element
      gi: "li"
      (process-children-trim))
    newline))

(element (listitem para)
  (make element
    gi: "p"
    (process-children-trim)))

(element para
  (make scroll
    (make element
      gi: "p"
      (process-children-trim))
    newline))

(element filename
  (make element
    gi: "tt"))
(element command
  (make element
    gi: "tt"))

(element ulink
  (make element
    gi: "tt"
    (literal (attribute-string "url"))))

(element (sect1 title)
  (make scroll
    (make element
      gi: "h1"
      (process-children-trim))
    newline))

(element (sect2 title)
  (make scroll
    (make element
      gi: "h2"
      (process-children))
    newline))

(element (sect3 title)
  (make scroll
    (make element
      gi: "h3"
      (process-children))
    newline))

(element sect1
  (process-children))

(element sect2 
  (process-children))

(element sect3
  (process-children))
 
</style-specification-body>
</style-specification>

</style-sheet>

