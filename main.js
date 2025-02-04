// Simplify meanmenu initialization to match about page
$(document).ready(function ($) {
  $("#mobile-menu").meanmenu({
    meanMenuContainer: ".mobile-menu",
    meanScreenWidth: "992",
    meanExpand: "+",
    meanContract: "-",
    meanRevealPosition: "right",
    meanRemoveAttrs: true,
    removeElements: ".mean-remove",
    meanExpandableChildren: true,
    meanInitialChildren: false,
  });
});
