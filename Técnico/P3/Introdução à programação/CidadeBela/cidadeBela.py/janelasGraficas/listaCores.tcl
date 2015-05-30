#!/bin/sh
# the next line restarts using wish\
exec wish "$0" "$@" 

if {![info exists vTcl(sourcing)]} {

    # Provoke name search
    catch {package require bogus-package-name}
    set packageNames [package names]

    package require Tk
    switch $tcl_platform(platform) {
    windows {
            option add *Button.padY 0
    }
    default {
            option add *Scrollbar.width 10
            option add *Scrollbar.highlightThickness 0
            option add *Scrollbar.elementBorderWidth 2
            option add *Scrollbar.borderWidth 2
    }
    }
    
}

#############################################################################
# Visual Tcl v1.60 Project
#


#################################
# VTCL LIBRARY PROCEDURES
#

if {![info exists vTcl(sourcing)]} {
#############################################################################
## Library Procedure:  Window

proc ::Window {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global vTcl
    foreach {cmd name newname} [lrange $args 0 2] {}
    set rest    [lrange $args 3 end]
    if {$name == "" || $cmd == ""} { return }
    if {$newname == ""} { set newname $name }
    if {$name == "."} { wm withdraw $name; return }
    set exists [winfo exists $newname]
    switch $cmd {
        show {
            if {$exists} {
                wm deiconify $newname
            } elseif {[info procs vTclWindow$name] != ""} {
                eval "vTclWindow$name $newname $rest"
            }
            if {[winfo exists $newname] && [wm state $newname] == "normal"} {
                vTcl:FireEvent $newname <<Show>>
            }
        }
        hide    {
            if {$exists} {
                wm withdraw $newname
                vTcl:FireEvent $newname <<Hide>>
                return}
        }
        iconify { if $exists {wm iconify $newname; return} }
        destroy { if $exists {destroy $newname; return} }
    }
}
#############################################################################
## Library Procedure:  vTcl:DefineAlias

proc ::vTcl:DefineAlias {target alias widgetProc top_or_alias cmdalias} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    global widget
    set widget($alias) $target
    set widget(rev,$target) $alias
    if {$cmdalias} {
        interp alias {} $alias {} $widgetProc $target
    }
    if {$top_or_alias != ""} {
        set widget($top_or_alias,$alias) $target
        if {$cmdalias} {
            interp alias {} $top_or_alias.$alias {} $widgetProc $target
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:DoCmdOption

proc ::vTcl:DoCmdOption {target cmd} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## menus are considered toplevel windows
    set parent $target
    while {[winfo class $parent] == "Menu"} {
        set parent [winfo parent $parent]
    }

    regsub -all {\%widget} $cmd $target cmd
    regsub -all {\%top} $cmd [winfo toplevel $parent] cmd

    uplevel #0 [list eval $cmd]
}
#############################################################################
## Library Procedure:  vTcl:FireEvent

proc ::vTcl:FireEvent {target event {params {}}} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    ## The window may have disappeared
    if {![winfo exists $target]} return
    ## Process each binding tag, looking for the event
    foreach bindtag [bindtags $target] {
        set tag_events [bind $bindtag]
        set stop_processing 0
        foreach tag_event $tag_events {
            if {$tag_event == $event} {
                set bind_code [bind $bindtag $tag_event]
                foreach rep "\{%W $target\} $params" {
                    regsub -all [lindex $rep 0] $bind_code [lindex $rep 1] bind_code
                }
                set result [catch {uplevel #0 $bind_code} errortext]
                if {$result == 3} {
                    ## break exception, stop processing
                    set stop_processing 1
                } elseif {$result != 0} {
                    bgerror $errortext
                }
                break
            }
        }
        if {$stop_processing} {break}
    }
}
#############################################################################
## Library Procedure:  vTcl:Toplevel:WidgetProc

proc ::vTcl:Toplevel:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }
    set command [lindex $args 0]
    set args [lrange $args 1 end]
    switch -- [string tolower $command] {
        "setvar" {
            foreach {varname value} $args {}
            if {$value == ""} {
                return [set ::${w}::${varname}]
            } else {
                return [set ::${w}::${varname} $value]
            }
        }
        "hide" - "show" {
            Window [string tolower $command] $w
        }
        "showmodal" {
            ## modal dialog ends when window is destroyed
            Window show $w; raise $w
            grab $w; tkwait window $w; grab release $w
        }
        "startmodal" {
            ## ends when endmodal called
            Window show $w; raise $w
            set ::${w}::_modal 1
            grab $w; tkwait variable ::${w}::_modal; grab release $w
        }
        "endmodal" {
            ## ends modal dialog started with startmodal, argument is var name
            set ::${w}::_modal 0
            Window hide $w
        }
        default {
            uplevel $w $command $args
        }
    }
}
#############################################################################
## Library Procedure:  vTcl:WidgetProc

proc ::vTcl:WidgetProc {w args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.

    if {[llength $args] == 0} {
        ## If no arguments, returns the path the alias points to
        return $w
    }

    set command [lindex $args 0]
    set args [lrange $args 1 end]
    uplevel $w $command $args
}
#############################################################################
## Library Procedure:  vTcl:toplevel

proc ::vTcl:toplevel {args} {
    ## This procedure may be used free of restrictions.
    ##    Exception added by Christian Gavin on 08/08/02.
    ## Other packages and widget toolkits have different licensing requirements.
    ##    Please read their license agreements for details.
    uplevel #0 eval toplevel $args
    set target [lindex $args 0]
    namespace eval ::$target {set _modal 0}
}
}


if {[info exists vTcl(sourcing)]} {

proc vTcl:project:info {} {
    set base .top32
    namespace eval ::widgets::$base {
        set set,origin 1
        set set,size 1
        set runvisible 1
    }
    set site_3_0 $base.tLa46
    set site_3_0 $base.m58
    namespace eval ::widgets_bindings {
        set tagslist _TopLevel
    }
    namespace eval ::vTcl::modules::main {
        set procs {
        }
        set compounds {
        }
        set projectType single
    }
}
}

#################################
# USER DEFINED PROCEDURES
#

#################################
# VTCL GENERATED GUI PROCEDURES
#

proc vTclWindow. {base} {
    if {$base == ""} {
        set base .
    }
    ###################
    # CREATING WIDGETS
    ###################
    wm focusmodel $top passive
    wm geometry $top 200x200+75+75; update
    wm maxsize $top 1370 750
    wm minsize $top 116 1
    wm overrideredirect $top 0
    wm resizable $top 1 1
    wm withdraw $top
    wm title $top "page"
    bindtags $top "$top Page all"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ###################
    # SETTING GEOMETRY
    ###################

    vTcl:FireEvent $base <<Ready>>
}

proc vTclWindow.top32 {base} {
    if {$base == ""} {
        set base .top32
    }
    if {[winfo exists $base]} {
        wm deiconify $base; return
    }
    set top $base
    ###################
    # CREATING WIDGETS
    ###################
    vTcl:toplevel $top -class Toplevel \
        -menu "$top.m58" 
    wm focusmodel $top passive
    wm geometry $top 402x304+363+93; update
    wm maxsize $top 1374 740
    wm minsize $top 126 1
    wm overrideredirect $top 0
    wm resizable $top 0 0
    wm deiconify $top
    wm title $top "Janelas"
    vTcl:DefineAlias "$top" "Toplevel1" vTcl:Toplevel:WidgetProc "" 1
    bindtags $top "$top Toplevel all _TopLevel"
    vTcl:FireEvent $top <<Create>>
    wm protocol $top WM_DELETE_WINDOW "vTcl:FireEvent $top <<DeleteWindow>>"

    ttk::labelframe $top.tLa46 \
        -text {Configurando lista} -width 355 -height 225 
    vTcl:DefineAlias "$top.tLa46" "TLabelframe1" vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $top.tLa46
    listbox $site_3_0.lis51 \
        -background white 
    vTcl:DefineAlias "$site_3_0.lis51" "Listbox1" vTcl:WidgetProc "Toplevel1" 1
    canvas $site_3_0.can33 \
        -borderwidth 2 -closeenough 1.0 -height 113 -relief ridge -width 126 
    vTcl:DefineAlias "$site_3_0.can33" "Canvas1" vTcl:WidgetProc "Toplevel1" 1
    ttk::button $site_3_0.tBu34 \
        -takefocus {} -text Adicionar -takefocus {} 
    vTcl:DefineAlias "$site_3_0.tBu34" "TButton6" vTcl:WidgetProc "Toplevel1" 1
    place $site_3_0.lis51 \
        -in $site_3_0 -x 10 -y 50 -anchor nw -bordermode ignore 
    place $site_3_0.can33 \
        -in $site_3_0 -x 220 -y 50 -width 126 -height 113 -anchor nw \
        -bordermode ignore 
    place $site_3_0.tBu34 \
        -in $site_3_0 -x 250 -y 170 -anchor nw -bordermode ignore 
    ttk::button $top.cpd47 \
        -takefocus {} -text Inserir -takefocus {} 
    vTcl:DefineAlias "$top.cpd47" "TButton3" vTcl:WidgetProc "Toplevel1" 1
    ttk::button $top.cpd48 \
        -takefocus {} -text Remover -takefocus {} 
    vTcl:DefineAlias "$top.cpd48" "TButton4" vTcl:WidgetProc "Toplevel1" 1
    message $top.cpd49 \
        -text {Todas as janelas} -width 100 
    vTcl:DefineAlias "$top.cpd49" "Message3" vTcl:WidgetProc "Toplevel1" 1
    message $top.cpd50 \
        -text {Lista de janelas} -width 100 
    vTcl:DefineAlias "$top.cpd50" "Message4" vTcl:WidgetProc "Toplevel1" 1
    ttk::button $top.tBu53 \
        -takefocus {} -text Alterar -takefocus {} 
    vTcl:DefineAlias "$top.tBu53" "TButton1" vTcl:WidgetProc "Toplevel1" 1
    ttk::button $top.tBu54 \
        -takefocus {} -text Cancelar -takefocus {} 
    vTcl:DefineAlias "$top.tBu54" "TButton2" vTcl:WidgetProc "Toplevel1" 1
    ttk::combobox $top.tCo55 \
        -takefocus {} -textvariable Teste -takefocus {} 
    vTcl:DefineAlias "$top.tCo55" "TCombobox1" vTcl:WidgetProc "Toplevel1" 1
    message $top.mes56 \
        -text Prédio: -width 70 
    vTcl:DefineAlias "$top.mes56" "Message1" vTcl:WidgetProc "Toplevel1" 1
    menu $top.m58 \
        -activeborderwidth 1 -borderwidth 1 -cursor {} -font {{Segoe UI} 9} 
    $top.m58 add cascade \
        -menu "$top.m58.men59" -label Elementos 
    set site_3_0 $top.m58
    menu $site_3_0.men59 \
        -activeborderwidth 1 -borderwidth 1 -font {{Segoe UI} 9} -tearoff 0 
    $site_3_0.men59 add command \
        -command TODO -label {Selecione o elemento:} -state disabled 
    $site_3_0.men59 add separator \
        
    $site_3_0.men59 add radiobutton \
        -value {New radio} -command TODO -label Janelas -state active 
    $site_3_0.men59 add radiobutton \
        -indicatoron 0 -value {New radio} -command TODO -label Portas 
    $site_3_0.men59 add radiobutton \
        -indicatoron 0 -value {New radio} -command TODO -label Tetos 
    ttk::button $top.tBu33 \
        -takefocus {} -text {Visualizar elemento} -takefocus {} 
    vTcl:DefineAlias "$top.tBu33" "TButton5" vTcl:WidgetProc "Toplevel1" 1
    ###################
    # SETTING GEOMETRY
    ###################
    place $top.tLa46 \
        -in $top -x 20 -y 60 -width 355 -height 225 -anchor nw \
        -bordermode ignore 
    place $top.cpd47 \
        -in $top -x 160 -y 150 -anchor nw -bordermode inside 
    place $top.cpd48 \
        -in $top -x 160 -y 180 -anchor nw -bordermode inside 
    place $top.cpd49 \
        -in $top -x 250 -y 80 -anchor nw -bordermode inside 
    place $top.cpd50 \
        -in $top -x 40 -y 80 -anchor nw -bordermode inside 
    place $top.tBu53 \
        -in $top -x 230 -y 290 -anchor nw -bordermode ignore 
    place $top.tBu54 \
        -in $top -x 310 -y 290 -anchor nw -bordermode ignore 
    place $top.tCo55 \
        -in $top -x 240 -y 20 -width 132 -height 21 -anchor nw \
        -bordermode ignore 
    place $top.mes56 \
        -in $top -x 190 -y 20 -anchor nw -bordermode ignore 
    place $top.tBu33 \
        -in $top -x 20 -y 290 -anchor nw -bordermode ignore 

    vTcl:FireEvent $base <<Ready>>
}

#############################################################################
## Binding tag:  _TopLevel

bind "_TopLevel" <<Create>> {
    if {![info exists _topcount]} {set _topcount 0}; incr _topcount
}
bind "_TopLevel" <<DeleteWindow>> {
    if {[set ::%W::_modal]} {
                vTcl:Toplevel:WidgetProc %W endmodal
            } else {
                destroy %W; if {$_topcount == 0} {exit}
            }
}
bind "_TopLevel" <Destroy> {
    if {[winfo toplevel %W] == "%W"} {incr _topcount -1}
}

Window show .
Window show .top32

