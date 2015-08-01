###
# A plugin for making Bootstrap's pagination more responsive
# original: https://github.com/auxiliary/rpage
###

'use strict'

isNextOrPrevLink = (element) ->
    text = element.text().trim()
    text is '»' or text is '«' or
    element.hasClass('pagination-prev') or element.hasClass('pagination-next')

class rPage
    constructor: (@$container) ->
        @els = @$container.find 'li'
        @defaultLarge = @$container.hasClass 'pagination-lg'
        @label()
        @makeResponsive()

        resizeTimer = null
        self = this
        $(window).resize ->
            clearTimeout resizeTimer
            resizeTimer = setTimeout ->
                self.makeResponsive()
            , 100

    label: ->
        active_index = @els.filter('.active').index()
        for el in @els
            $el = $(el)
            $el.addClass if not isNextOrPrevLink $el
                "page-away-#{Math.abs active_index - $el.index()}"
            else if $el.index() > active_index
                'right-etc'
            else
                'left-etc'
        return

    isTooLong: ->
        MARGIN = 10
        @calculateWidth() > @$container.parent().innerWidth() - MARGIN

    makeResponsive: ->
        @reset()

        if @defaultLarge and @isTooLong()
            @$container.removeClass 'pagination-lg'
        while @isTooLong()
            if not @removeOne()
                break
        return

    isRemovable: (element) ->
        if isNextOrPrevLink element
            return false
        index = element.index()
        if index == 1 or isNextOrPrevLink @$container.find('li').eq index + 1
            return false
        element.text().trim() isnt '...'

    removeOne: ->
        active_index = @els.filter('.active').index()
        farthest_index = @$container.find('li').length - 1
        next = active_index + 1
        prev = active_index - 1

        for i in [farthest_index - 1...0]
            candidates = @els.filter ".page-away-#{i}:visible"
            for candidate in candidates
                candid_candidate = $(candidate)
                if @isRemovable candid_candidate
                    candid_candidate.css 'display', 'none'
                    if @needsEtcSign active_index, farthest_index - 1
                        @els.eq(farthest_index - 2).before '<li class="disabled removable"><span>...</span></li>'
                    if @needsEtcSign 1, active_index
                        @els.eq(1).after '<li class="disabled removable"><span>...</span></li>'
                    return true
        false

    needsEtcSign: (el1_index, el2_index) ->
        if el2_index - el1_index <= 1
            return false
        hasEtcSign = false
        hasHiddenElement = false
        $li = @$container.find 'li'
        for i in [el1_index + 1...el2_index]
            el = $li.eq(i)
            if el.css('display') is 'none'
                hasHiddenElement = true
            if el.text() is '...'
                hasEtcSign = true
        hasHiddenElement and not hasEtcSign

    reset: ->
        if @defaultLarge
            @$container.addClass 'pagination-lg'
        @els.css 'display', ''
        @$container.find('li').filter('.removable').remove()
        return

    calculateWidth: ->
        width = 0
        for e in @$container.parent().children()
            width += $(e).outerWidth true
        width

do (jQuery) ->
    $ = jQuery
    $.fn.rPage = ->
        $this = $(this)
        for i in [0...$this.length]
            new rPage $($this[i])
