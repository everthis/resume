tagElements = (p, ele) ->
  p.getElementsByTagName ele

idElement = (id) ->
  document.getElementById id

eventListener = (obj, element, func) ->
  if obj.addEventListener then obj.addEventListener(element, func, false) else obj.attachEvent('on' + element, func)

carousel = ->
carousel.prototype.init = (opt) ->
	arg = this.set()
	wrap = idElement(opt.gallery)
	ctl = idElement(opt.control)
	obj = this.obj = tagElements(wrap, 'ul')[0]
	$this = this
	this.u = tagElements(obj, 'li')
	this.cu = tagElements(ctl, 'li')
	this.uW = this.u[0].offsetWidth
	this.uH = this.u[0].offsetHeight
	this.len = this.u.length
	this.old = this.cur = arg.index
	wrap.style.cssText = 'width:' + this.uW + 'px;' + 'height:' + this.uH + 'px;' + 'overflow: hidden;'
	obj.style.cssText = 'height:' + this.uH + 'px;' + 'width:' + (arg.dir ? this.uW + 'px;' : this.len * this.uW + 'px;') + (arg.dir ? 'top:' + -1 * this.cur * this.uH + 'px;' : 'left:' + -1 * this.cur * this.uW + 'px;')
	this.cu[this.cur].className = 'current'
	this.event(arg.type)
	setTimeout ( ->
	  $this.auto()
	), arg.interval

carousel.prototype.set = () ->
	org =
	  gallery: "gal-wrap"
	  control: "gal-panel"
	  dir: true
	  index: 0
	  speed: 20
	  interval: 1000
	  type: "click"
	org[p] = opt[p] for p in opt

carousel.prototype.timeMgr = ->
	$this = this
	this.m = setTimeout ( ->
	  $this.auto()
	  $this.indexMgr()
	  ), arg.interval

carousel.prototype.auto = ->
	$this = this
	clearInterval this.a if this.a?
	this.a = setInterval ( ->
	  $this.pos()
	  ), arg.speed

carousel.prototype.pos = -> 
	dir = if arg.dir then parseInt(this.obj.style.top) else parseInt(this.obj.style.left)
	area = if arg.dir then this.uH else this.uW
	dis = (area * this.cur + dir) * .1
	step = if dis >= 0 then Math.ceil(dis) else Math.floor(dis)
	if arg.dir then this.obj.style.top = dir - step + 'px' else this.obj.style.left = dir - step + 'px'
	this.stop(dir, area)

carousel.prototype.stop = (dir, area) ->
	if Math.abs(dir) == area * this.cur
	  clearInterval(this.a)
	  if this.cur == this.len - 1 then this.cur = 0 else this.cur++
	  this.timeMgr()

carousel.prototype.indexMgr = ->
	this.cu[this.cur].className = 'current'
	if this.old != this.cur
	  this.cu[this.old].className = ''
	  this.old = this.cur

carousel.prototype.event = (event) ->
	eventListener this.cu[i], event, num(i, $this) for i in this.cu
	num = (n, $this) ->
	   clearInterval($this.a)
	   clearTimeout($this.m)
	   $this.cu[n].className = 'current'
	   if $this.old != n
	     $this.cu[$this.old].className = ''
	     $this.old = $this.cur = n
	   $this.c = 0
	   $this.auto()
console.log carousel
carousel.init














