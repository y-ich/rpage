rpage
=====

Highly responsive pagination for Bootstrap

The original rpage is http://auxiliary.github.io/rpage/ and this is re-written in CoffeeScript and is refactored.

Usage
=====

Just include `responsive-pagination.css` and `responsive-pagination.js` and call the `rPage` function on the pagination element like this:

```javascript
$(document).ready(function () {
    $(".pagination").rPage();
});
```

Previous and Next Links
=======================

rPage won't hide previous and next links with bootstrap's default "«" and "»" content. If you want to use custom text in
your links, add classes to your list items like this:

```html
<ul class="pagination">
  <li class="pagination-prev"><a href="#">Previous</a></li>
  <!-- ... -->
  <li class="pagination-next"><a href="#">Next</a></li>
</ul>
```

Assumption
==========

All siblings of .pagination are inline and rPage make those elements one line responsively.

Behavior
========

If you have .pagination-lg, rPage first remove this class when pagination is overflow.
