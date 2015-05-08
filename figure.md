<html>
<head>
<style type="text/css">
 .row { vertical-align: top; height:auto !important; } 
 .list {display:none; } 
 .show {display: none; } 
 .hide:focus + .show {display: inline; } 
 .hide:focus {display: none; } 
 .hide:focus ~ .list {display: inline; } 
 @media print { .hide, .show { display: none; } } 
 </style>
 </head>

<body>
<div class="row">
 <a href="#hide1" class="hide" id="hide1">Demand module</a>
 <a href="#show1" class="show" id="show1">Demand module</a>
 <div class="list">
 <ul>
 <li>EQCONS_H_T(prd,regg): demand of households for products on aggregated product level</li>
 <li>EQCONS_G_T(prd,regg): demand of government for products on aggregated product level</li>
 <li>EQGFCF_T(prd,regg): demand of investment agent for products on aggregated
 product level</li>
 <li>EQFACREV(reg,va): revenue from factors of production</li>
 <li>EQTSPREV(reg): revenue from net tax on products</li>
 <li>EQNTPREV(reg): revenue from net tax on production</li>
 <li>EQTIMREV(reg): revenue from tax on export and international margins</li>
 <li>EQGRINC_H(regg): gross income of households</li>
 <li>EQGRINC_G(regg): gross income of government</li>
 <li>EQGRINC_I(regg): gross income of investment agent</li>
 <li>EQCBUD_H(regg): budget available for household consumption</li>
 <li>EQCBUD_G(regg): budget available for government consumption</li>
 <li>EQCBUD_I(regg): budget available for gross fixed capital formation</li>
 <li>EQSCLFD_H(regg): budget constraint of households</li>
 <li>EQSCLFD_G(regg): budget constraint of government</li>
 <li>EQSCLFD_I(regg): budget constraint of investment agent</li>
 </ul>
 </div>
 </div>

<div class="row">
 <a href="#hide2" class="hide" id="hide2">Trade module</a>
 <a href="#show2" class="show" id="show2">Trade module</a>
 <div class="list">
 <ul>
 <li>EQINTU_D(prd,regg,ind): demand for domestically produced intermediate inputs</li>
 <li>EQINTU_M(prd,regg,ind): demand for aggregated imported intermediate inputs</li>
 <li>EQCONS_H_D(prd,regg): demand of households for domestically produced products</li>
 <li>EQCONS_H_M(prd,regg): demand of households for aggregated products imported from modeled regions</li>
 <li>EQCONS_G_D(prd,regg): demand of government for domesrically produced products</li>
 <li>EQCONS_G_M(prd,regg): demand of government for aggregated products imported from modeled regions</li>
 <li>EQGFCF_D(prd,regg): demand of investment agent for domestically produced products</li>
 <li>EQGFCF_M(prd,regg): demand of investment agent for aggregated products imported from modeled regions</li>
 <li>EQSV(reg,prd,regg): demand for stock changes of products on the most detailed</li>
 level 
 <li>EQIMP_T(prd,regg): total demand for aggregared imported products</li>
 <li>EQIMP_MOD(prd,regg): demand for aggregated import from modeled regions</li>
 <li>EQIMP_ROW(prd,regg): demand for import from rest of the world region</li>
 <li>EQTRADE(reg,prd,regg): demand for bi-lateral trade transactions</li>
 <li>EQEXP(reg,prd): export supply to the rest of the world region</li>
 </ul>
 </div>
 </div>

<div class="row">
 <a href="#hide4" class="hide" id="hide4">Production module</a>
 <a href="#show4" class="show" id="show4">Production module</a>
 <div class="list">
 <ul>
 <li>EQBAL(reg,prd): product market balance</li>
 <li>EQX(reg,prd): supply of products with mix per industry</li>
 <li>EQY(regg,ind): supply of activities with mix per product</li>
 <li>EQINTU_T(prd,regg,ind): demand for intermediate inputs on aggregated product level</li>
 <li>EQVA(regg,ind): demand for aggregated production factors</li>
 <li>EQKL(reg,va,regg,ind): demand for specific production factors</li>
 <li>EQGDPCUR(regg): GDP in current prices (value)</li>
 <li>EQGDPCONST(regg): GDP in constant prices (volume)</li>
 </ul>
 </div>
 </div>

<div class="row">
 <a href="#hide3" class="hide" id="hide3">Price module</a>
 <a href="#show3" class="show" id="show3">Price module</a>
 <div class="list">
 <ul>
 <li>EQPY(regg,ind): zero-profit condition (including possible margins)</li>
 <li>EQP(reg,prd): balance between product price and industry price</li>
 <li>EQPKL(reg,va): balance on production factors market</li>
 <li>EQPVA(regg,ind): balance between specific production factors price and aggregate production factors price</li>
 <li>EQPIU(prd,regg,ind): balance between specific product price and aggregate product price for intermediate use</li>
 <li>EQPC_H(prd,regg): balance between specific product price and aggregate product price for household consumption</li>
 <li>EQPC_G(prd,regg): balance between specific product price and aggregate product price for government consumption</li>
 <li>EQPC_I(prd,regg): balance between specific product price and aggregate product
 price for gross fixed capital formation</li>
 <li>EQPIMP_T(prd,regg): balance between specific imported product price from rest of the world and modeled regions and total aggregated imported product price</li>
 <li>EQPIMP_MOD(prd,regg): balance between specific imported product price from modeled regions and corresponding aggregated imported product price</li>
 <li>EQPROW: balance of payments with rest of the world</li>
 <li>EQPAASCHE(regg): Paasche price index for household consumption</li>
 <li>EQLASPEYRES(regg): Laspeyres price index for household consumption</li>
 <li>EQGDPDEF: GDP deflator used as numeraire</li>
 <li>EQOBJ: artificial objective function</li>
 </ul>
 </div>
 </div>

</body>
</html>


<!doctype HTML>
<meta charset = 'utf-8'>
<html>
  <head>
    <link rel='stylesheet' href='http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/css/sankey.css'>
    
    <script src='http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/js/d3.v3.js' type='text/javascript'></script>
    <script src='http://timelyportfolio.github.io/rCharts_d3_sankey/libraries/widgets/d3_sankey/js/sankey.js' type='text/javascript'></script>
    
    <style>
    .rChart {
      display: block;
      margin-left: auto; 
      margin-right: auto;
      width: 1200px;
      height: 800px;
    }  
    </style>
    
  </head>
  <body >
    
    <div id = 'chart140763e651c' class = 'rChart d3_sankey'></div>    
    ﻿<!--Attribution:
Mike Bostock https://github.com/d3/d3-plugins/tree/master/sankey
Mike Bostock http://bost.ocks.org/mike/sankey/
-->

<script>
(function(){
var params = {
 "dom": "chart140763e651c",
"width":   1200,
"height":    800,
"data": {
 "source": [ "CBUD_G_V(regg): budget available for government consumption", "CBUD_H_V(regg):budget available for household consumption", "CBUD_I_V(regg): budget available for gross fixed capital formation", "CONS_G_T_V(prd,regg): government consumption on aggregated product level", "CONS_H_T_V(prd,regg): household consumption on aggregated product", "FACREV_V(reg,va):revenue from factors of production", "GFCF_T_V(prd,regg): gross fixed capital formation on aggregated product level", "GRINC_G_V(regg):gross income of government", "GRINC_H_V(regg):gross income of households", "GRINC_I_V(regg):gross income of investment agent", "NTPREV_V(reg):revenue from net tax on production", "SCLFD_G_V(regg: scale parameter for government consumption", "SCLFD_H_V(regg): scale parameter for household consumption", "SCLFD_I_V(regg):scale parameter for gross fixed capital formation", "TIMREV_V(reg):revenue from tax on export and international margins", "TSPREV_V(reg):revenue from net tax on products", "CONS_G_T_V(prd,regg): government consumption on aggregated product level", "CONS_G_T_V(prd,regg): government consumption on aggregated product level", "CONS_G_T_V(prd,regg): government consumption on aggregated product level", "CONS_H_T_V(prd,regg): household consumption on aggregated product", "CONS_H_T_V(prd,regg): household consumption on aggregated product", "CONS_H_T_V(prd,regg): household consumption on aggregated product", "GFCF_T_V(prd,regg): gross fixed capital formation on aggregated product level", "GFCF_T_V(prd,regg): gross fixed capital formation on aggregated product level", "GFCF_T_V(prd,regg): gross fixed capital formation on aggregated product level", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand", "Demand" ],
"target": [ "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Demand(origin)", "Production", "Price", "Trade", "Production", "Price", "Trade", "Production", "Price", "Trade", "CBUD_G_V(regg): budget available for government consumption", "CBUD_H_V(regg):budget available for household consumption", "CBUD_I_V(regg): budget available for gross fixed capital formation", "CONS_G_T_V(prd,regg): government consumption on aggregated product level", "CONS_H_T_V(prd,regg): household consumption on aggregated product", "FACREV_V(reg,va):revenue from factors of production", "GFCF_T_V(prd,regg): gross fixed capital formation on aggregated product level", "GRINC_G_V(regg):gross income of government", "GRINC_H_V(regg):gross income of households", "GRINC_I_V(regg):gross income of investment agent", "NTPREV_V(reg):revenue from net tax on production", "SCLFD_G_V(regg: scale parameter for government consumption", "SCLFD_H_V(regg): scale parameter for household consumption", "SCLFD_I_V(regg):scale parameter for gross fixed capital formation", "TIMREV_V(reg):revenue from tax on export and international margins", "TSPREV_V(reg):revenue from net tax on products" ],
"value": [      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      1,      4,      4,      1,      4,      1,      1,      1,      1,      1,      1,      1,      1,      1 ] 
},
"nodeWidth":     10,
"nodePadding":      5,
"layout":     32,
"id": "chart140763e651c" 
};

params.units ? units = " " + params.units : units = "";

//hard code these now but eventually make available
var formatNumber = d3.format("0,.0f"),    // zero decimal places
    format = function(d) { return formatNumber(d) + units; },
    color = d3.scale.category20();

if(params.labelFormat){
  formatNumber = d3.format(".2%");
}

var svg = d3.select('#' + params.id).append("svg")
    .attr("width", params.width)
    .attr("height", params.height);
    
var sankey = d3.sankey()
    .nodeWidth(params.nodeWidth)
    .nodePadding(params.nodePadding)
    .layout(params.layout)
    .size([params.width,params.height]);
    
var path = sankey.link();
    
var data = params.data,
    links = [],
    nodes = [];
    
//get all source and target into nodes
//will reduce to unique in the next step
//also get links in object form
data.source.forEach(function (d, i) {
    nodes.push({ "name": data.source[i] });
    nodes.push({ "name": data.target[i] });
    links.push({ "source": data.source[i], "target": data.target[i], "value": +data.value[i] });
}); 

//now get nodes based on links data
//thanks Mike Bostock https://groups.google.com/d/msg/d3-js/pl297cFtIQk/Eso4q_eBu1IJ
//this handy little function returns only the distinct / unique nodes
nodes = d3.keys(d3.nest()
                .key(function (d) { return d.name; })
                .map(nodes));

//it appears d3 with force layout wants a numeric source and target
//so loop through each link replacing the text with its index from node
links.forEach(function (d, i) {
    links[i].source = nodes.indexOf(links[i].source);
    links[i].target = nodes.indexOf(links[i].target);
});

//now loop through each nodes to make nodes an array of objects rather than an array of strings
nodes.forEach(function (d, i) {
    nodes[i] = { "name": d };
});

sankey
  .nodes(nodes)
  .links(links)
  .layout(params.layout);
  
var link = svg.append("g").selectAll(".link")
  .data(links)
.enter().append("path")
  .attr("class", "link")
  .attr("d", path)
  .style("stroke-width", function (d) { return Math.max(1, d.dy); })
  .sort(function (a, b) { return b.dy - a.dy; });

link.append("title")
  .text(function (d) { return d.source.name + " → " + d.target.name + "\n" + format(d.value); });

var node = svg.append("g").selectAll(".node")
  .data(nodes)
.enter().append("g")
  .attr("class", "node")
  .attr("transform", function (d) { return "translate(" + d.x + "," + d.y + ")"; })
.call(d3.behavior.drag()
  .origin(function (d) { return d; })
  .on("dragstart", function () { this.parentNode.appendChild(this); })
  .on("drag", dragmove));

node.append("rect")
  .attr("height", function (d) { return d.dy; })
  .attr("width", sankey.nodeWidth())
  .style("fill", function (d) { return d.color = color(d.name.replace(/ .*/, "")); })
  .style("stroke", function (d) { return d3.rgb(d.color).darker(2); })
.append("title")
  .text(function (d) { return d.name + "\n" + format(d.value); });

node.append("text")
  .attr("x", -6)
  .attr("y", function (d) { return d.dy / 2; })
  .attr("dy", ".35em")
  .attr("text-anchor", "end")
  .attr("transform", null)
  .text(function (d) { return d.name; })
.filter(function (d) { return d.x < params.width / 2; })
  .attr("x", 6 + sankey.nodeWidth())
  .attr("text-anchor", "start");

// the function for moving the nodes
  function dragmove(d) {
    d3.select(this).attr("transform", 
        "translate(" + (
                   d.x = Math.max(0, Math.min(params.width - d.dx, d3.event.x))
                ) + "," + (
                   d.y = Math.max(0, Math.min(params.height - d.dy, d3.event.y))
                ) + ")");
        sankey.relayout();
        link.attr("d", path);
  }
})();
</script>
    
    <script></script>    
  </body>
</html>

