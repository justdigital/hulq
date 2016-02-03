jQuery(document).ready(function ($) {
  var owl              = $('.slides'),
      speed            = 300,
      warning          = $('.warning'),
      warningShowClass = 'show',
      warningShowed    = false;

  var checkAndRemoveClass = function (warning, cls) {
    if(warning.hasClass(cls)) {
      warning.removeClass(cls);
    }
  };

  owl.owlCarousel({
    loop         : true,
    stageElement : 'ul',
    itemElement  : 'li',
    items        : 1,
    nav          : false,
    dots         : false,
    mouseDrag    : false,
  });

  $(document).on('keydown', function (e) {
    var code  = e.keyCode || e.which,
        left  = 37,
        right = 39;

    if(code === left) {
      owl.trigger('prev.owl.carousel', [speed]);
      checkAndRemoveClass(warning, warningShowClass);
    }

    if(code === right) {
      owl.trigger('next.owl.carousel', [speed]);
      checkAndRemoveClass(warning, warningShowClass);
    }
  });

  $('.arrow--right').on('click', function (e) {
    owl.trigger('next.owl.carousel', [speed]);

    if(!warningShowed && !warning.hasClass(warningShowClass)) {
      warning.addClass(warningShowClass);

      warningShowed = true;
    }
    else {
      checkAndRemoveClass(warning, warningShowClass);
    }
  });

  $('.arrow--left').on('click', function (e) {
    owl.trigger('prev.owl.carousel', [speed]);

    if(!warningShowed && !warning.hasClass(warningShowClass)) {
      warning.addClass(warningShowClass);

      warningShowed = true;
    }
    else {
      checkAndRemoveClass(warning, warningShowClass);
    }
  });

  owl.on('dragged.owl.carousel', function (e) {
    checkAndRemoveClass(warning, warningShowClass);
  });

  owl.on('changed.owl.carousel', function (property) {
    var currentSlide = property.item.index - 1;

    if(currentSlide >= 2) {
      $('.arrow--left').removeClass('hidden');
    }
  });

  $('.arrow--down').on('click', function (e) {
    $('html, body').animate({scrollTop: $("#hulq-info").offset().top}, 700);
  });
});
