<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="server" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1438881761591"><hook NAME="MapStyle">

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node">
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right">
<stylenode LOCALIZED_TEXT="default" MAX_WIDTH="600" COLOR="#000000" STYLE="as_parent">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details" COLOR="#999999"/>
<stylenode LOCALIZED_TEXT="defaultstyle.note"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="7"/>
<node TEXT="ideas" POSITION="right" ID="ID_207582701" CREATED="1438460481240" MODIFIED="1438460484609">
<edge COLOR="#7c0000"/>
<node TEXT="multi server" ID="ID_1953031236" CREATED="1438460485515" MODIFIED="1438894836646">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="full configurable" ID="ID_1580239966" CREATED="1438460495683" MODIFIED="1438894838704">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="init -&gt; load and init all configured server" ID="ID_1433282248" CREATED="1438462003253" MODIFIED="1438894842046">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="easy start and stop" ID="ID_1868976368" CREATED="1438460525744" MODIFIED="1438894844486">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="select server as path" ID="ID_106091402" CREATED="1438539661839" MODIFIED="1438539925413">
<node TEXT="label" ID="ID_1210124529" CREATED="1438539686921" MODIFIED="1438541491320"/>
<node TEXT="vhost" ID="ID_1802621451" CREATED="1438539699305" MODIFIED="1438541498154"/>
<node TEXT="context" ID="ID_1261175989" CREATED="1438539703186" MODIFIED="1438541527199"/>
</node>
<node TEXT="auth" ID="ID_236096689" CREATED="1438461065773" MODIFIED="1438541918231">
<node TEXT="by ip, port, domain" ID="ID_339109658" CREATED="1438461072147" MODIFIED="1438461107584"/>
<node TEXT="for individual path" ID="ID_286724966" CREATED="1438461107999" MODIFIED="1438461216618"/>
</node>
<node TEXT="automatic routing" ID="ID_1138285811" CREATED="1438460540345" MODIFIED="1438460569763">
<node TEXT="by ip, port, domain" ID="ID_576821440" CREATED="1438461072147" MODIFIED="1438461107584"/>
<node TEXT="for individual path" ID="ID_1659066722" CREATED="1438461107999" MODIFIED="1438461216618"/>
</node>
<node TEXT="set cahce control headers" ID="ID_426336369" CREATED="1438540967377" MODIFIED="1438540975062"/>
<node TEXT="caching" ID="ID_1702912058" CREATED="1438543373739" MODIFIED="1438543377872"/>
</node>
<node TEXT="steps" POSITION="right" ID="ID_619160702" CREATED="1438357756844" MODIFIED="1438357770863">
<edge COLOR="#ff00ff"/>
<node TEXT="config" ID="ID_884730765" CREATED="1438357809061" MODIFIED="1438458284297">
<node TEXT="schema" ID="ID_604443432" CREATED="1438458265461" MODIFIED="1438605946630">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="default" ID="ID_484328353" CREATED="1438458269829" MODIFIED="1438605947566">
<icon BUILTIN="button_ok"/>
</node>
</node>
<node TEXT="setup server by type" ID="ID_1268417110" CREATED="1438458260214" MODIFIED="1438894429674">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="http" ID="ID_740442935" CREATED="1438358010520" MODIFIED="1438358061288">
<node TEXT="start" ID="ID_747303902" CREATED="1438358065035" MODIFIED="1438358074286">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="listen" ID="ID_649810718" CREATED="1438358075095" MODIFIED="1438364155338">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="stop" ID="ID_630801636" CREATED="1438358080123" MODIFIED="1438894433218">
<icon BUILTIN="button_ok"/>
</node>
</node>
<node TEXT="debug" ID="ID_40013351" CREATED="1438894446183" MODIFIED="1438894450330">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="404" OBJECT="java.lang.Long|404" ID="ID_1304007697" CREATED="1438541940377" MODIFIED="1438541950841"/>
<node TEXT="500" OBJECT="java.lang.Long|500" ID="ID_1308398628" CREATED="1438919167942" MODIFIED="1438919170171"/>
<node TEXT="EADDRINUSE" ID="ID_1926916874" CREATED="1438547413013" MODIFIED="1438547417697"/>
<node TEXT="logging" ID="ID_1632568839" CREATED="1438541951380" MODIFIED="1438541963335">
<node TEXT="winston" ID="ID_1203070731" CREATED="1438542610755" MODIFIED="1438543101793"/>
<node TEXT="bind" ID="ID_304922268" CREATED="1439408837178" MODIFIED="1439408853777">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="request" ID="ID_1348882131" CREATED="1439408945826" MODIFIED="1439408953034">
<node TEXT="formatter" ID="ID_1229689217" CREATED="1439408855810" MODIFIED="1439408926152"/>
</node>
</node>
<node TEXT="start all configured" ID="ID_1734271464" CREATED="1438364220120" MODIFIED="1438364237985"/>
<node TEXT="route" ID="ID_35430529" CREATED="1438543202710" MODIFIED="1438543207231">
<node TEXT="static" ID="ID_1112784018" CREATED="1438543208900" MODIFIED="1438543217015"/>
<node TEXT="request" ID="ID_500488052" CREATED="1438543220419" MODIFIED="1438543266649"/>
<node TEXT="REST" ID="ID_1451991201" CREATED="1438543267176" MODIFIED="1438543271144">
<node TEXT="individual" ID="ID_1304403685" CREATED="1438543276889" MODIFIED="1438543280821"/>
<node TEXT="object" ID="ID_1934016826" CREATED="1438543281363" MODIFIED="1438543290042"/>
</node>
</node>
</node>
<node TEXT="function" POSITION="right" ID="ID_1413503838" CREATED="1438357739877" MODIFIED="1438357750835">
<edge COLOR="#0000ff"/>
<node TEXT="export" ID="ID_1008737414" CREATED="1438357815107" MODIFIED="1438357817702">
<node TEXT="setup" ID="ID_1998094637" CREATED="1438357819690" MODIFIED="1438364261958">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="init" ID="ID_1248610004" CREATED="1438357826704" MODIFIED="1438364262961">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="start" ID="ID_284429126" CREATED="1438364252876" MODIFIED="1438894400540">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="stop" ID="ID_175637225" CREATED="1438364256644" MODIFIED="1438894402799">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="http" ID="ID_1759776120" CREATED="1438458571946" MODIFIED="1438543170483">
<node TEXT="init" ID="ID_817439850" CREATED="1438459825276" MODIFIED="1438605883480">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="start" ID="ID_1959699218" CREATED="1438459199991" MODIFIED="1438894412898">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="stop" ID="ID_1585137319" CREATED="1438459202833" MODIFIED="1438894415010">
<icon BUILTIN="button_ok"/>
</node>
</node>
</node>
</node>
<node TEXT="variables" POSITION="right" ID="ID_120985788" CREATED="1438357751422" MODIFIED="1438357756313">
<edge COLOR="#00ff00"/>
<node TEXT="main" ID="ID_5876457" CREATED="1438357854093" MODIFIED="1438357869576">
<node TEXT="types" ID="ID_717488538" CREATED="1438357871050" MODIFIED="1438364285221">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="conf" ID="ID_759740249" CREATED="1438605889015" MODIFIED="1438605893859">
<icon BUILTIN="button_ok"/>
</node>
<node TEXT="http" ID="ID_1557964187" CREATED="1438605924838" MODIFIED="1438605928715">
<icon BUILTIN="button_ok"/>
</node>
</node>
<node TEXT="http" ID="ID_1806003895" CREATED="1438458402623" MODIFIED="1438605900019">
<node TEXT="server" ID="ID_1160664255" CREATED="1438459275969" MODIFIED="1438459277746"/>
<node TEXT="conf" ID="ID_1698619393" CREATED="1438605902863" MODIFIED="1438605907798">
<icon BUILTIN="button_ok"/>
</node>
</node>
</node>
<node TEXT="events" POSITION="right" ID="ID_1441895683" CREATED="1438357771901" MODIFIED="1438357779709">
<edge COLOR="#00ffff"/>
<node TEXT="start" ID="ID_539177028" CREATED="1438894529498" MODIFIED="1438894532734"/>
<node TEXT="stop" ID="ID_1249029636" CREATED="1438894533246" MODIFIED="1438894535740"/>
</node>
<node TEXT="config" POSITION="left" ID="ID_561745516" CREATED="1438357735531" MODIFIED="1438357738885">
<edge COLOR="#ff0000"/>
<node TEXT="http" ID="ID_1235677790" CREATED="1438458559874" MODIFIED="1438539296567">
<node TEXT="listen %" ID="ID_639970374" CREATED="1438541548854" MODIFIED="1438919138881">
<icon BUILTIN="button_ok"/>
<node TEXT="&lt;label&gt;" ID="ID_1025260188" CREATED="1438431351074" MODIFIED="1438541579056">
<node TEXT="host" ID="ID_350832095" CREATED="1438430335673" MODIFIED="1438919144586"/>
<node TEXT="port" ID="ID_1395209285" CREATED="1438430342697" MODIFIED="1438919146105"/>
<node TEXT="tls" ID="ID_1588092928" CREATED="1438430421053" MODIFIED="1438919147444">
<node TEXT="pfx" ID="ID_1061188729" CREATED="1438611397682" MODIFIED="1438611402342"/>
<node TEXT="key" ID="ID_232876585" CREATED="1438611402610" MODIFIED="1438611410318"/>
<node TEXT="passphrase" ID="ID_716431642" CREATED="1438611410674" MODIFIED="1438611413358"/>
<node TEXT="cert" ID="ID_1509642879" CREATED="1438611413681" MODIFIED="1438611416526"/>
<node TEXT="ca" ID="ID_1604079163" CREATED="1438611416769" MODIFIED="1438611419614"/>
<node TEXT="ciphers" ID="ID_824609705" CREATED="1438611419865" MODIFIED="1438611422006"/>
<node TEXT="rejectUnauthorized" ID="ID_655557536" CREATED="1438611422321" MODIFIED="1438611432617"/>
<node TEXT="secureProtocol" ID="ID_397448425" CREATED="1438611433042" MODIFIED="1438611437528"/>
</node>
<node TEXT="load" ID="ID_3791126" CREATED="1438753043207" MODIFIED="1438919149132">
<node TEXT="maxHeap" ID="ID_1944564531" CREATED="1438755675719" MODIFIED="1438755679604"/>
<node TEXT="maxRss" ID="ID_307792813" CREATED="1438755680383" MODIFIED="1438755684348"/>
<node TEXT="eventLoopDelay" ID="ID_1569161831" CREATED="1438755684919" MODIFIED="1438755692611"/>
</node>
</node>
</node>
<node TEXT="log @" ID="ID_1696451794" CREATED="1438539641613" MODIFIED="1438540047544">
<node TEXT="data $" ID="ID_1415076830" CREATED="1438892749816" MODIFIED="1438973281278">
<node TEXT="error" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_1339691501" CREATED="1438892829795" MODIFIED="1439388330861"/>
<node TEXT="event" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_1935972278" CREATED="1439279400997" MODIFIED="1439388330866"/>
<node TEXT="custom" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_686966495" CREATED="1439279404252" MODIFIED="1439388330870"/>
<node TEXT="combined" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_4334821" CREATED="1439279415572" MODIFIED="1439388330872"/>
<node TEXT="referrer" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_1027037485" CREATED="1439387770878" MODIFIED="1439388330874"/>
<node TEXT="extended" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_1170665785" CREATED="1439279419220" MODIFIED="1439388330876"/>
<node TEXT="all" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_245119987" CREATED="1439279427596" MODIFIED="1439388330877"/>
</node>
<node TEXT="bind" ID="ID_216381691" CREATED="1438892627707" MODIFIED="1439408305298">
<icon BUILTIN="button_ok"/>
<node TEXT="listen" ID="ID_1579586369" CREATED="1438539944698" MODIFIED="1438974571984">
<node TEXT="bind to specific server" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_112326073" CREATED="1439388321286" MODIFIED="1439408307774"/>
</node>
<node TEXT="domain" ID="ID_1405884174" CREATED="1438541852029" MODIFIED="1438974544200">
<node TEXT="bind to vhost name" LOCALIZED_STYLE_REF="defaultstyle.details" ID="ID_1079149560" CREATED="1439388417661" MODIFIED="1439388430338"/>
</node>
<node TEXT="context" ID="ID_250131535" CREATED="1438541856247" MODIFIED="1438541858997"/>
</node>
<node TEXT="file" ID="ID_708466238" CREATED="1438893090820" MODIFIED="1439388304288">
<node TEXT="filename" ID="ID_886507629" CREATED="1438539952516" MODIFIED="1438892715960"/>
<node TEXT="datePattern" ID="ID_1885225894" CREATED="1438892979605" MODIFIED="1438892986388"/>
<node TEXT="maxSize" ID="ID_262451453" CREATED="1438892730161" MODIFIED="1438892733730"/>
<node TEXT="maxFiles" ID="ID_1733505260" CREATED="1438892744660" MODIFIED="1438892748634"/>
<node TEXT="compress" ID="ID_641477382" CREATED="1438892920181" MODIFIED="1439048478924"/>
</node>
<node TEXT="http" ID="ID_1459400203" CREATED="1438893867963" MODIFIED="1438893997235">
<node TEXT="host" ID="ID_1610584304" CREATED="1438894038090" MODIFIED="1438894040844"/>
<node TEXT="port" ID="ID_1364628240" CREATED="1438894041136" MODIFIED="1438894043163"/>
<node TEXT="path" ID="ID_163090935" CREATED="1438894043434" MODIFIED="1438894047044"/>
<node TEXT="auth" ID="ID_1870088582" CREATED="1438894051370" MODIFIED="1438894053735">
<node TEXT="username" ID="ID_632989636" CREATED="1438894057979" MODIFIED="1438894066888"/>
<node TEXT="password" ID="ID_585585184" CREATED="1438894067456" MODIFIED="1438894072237"/>
</node>
<node TEXT="secure" ID="ID_1326373497" CREATED="1438894054892" MODIFIED="1438974823323"/>
</node>
<node TEXT="mail" ID="ID_676048872" CREATED="1438894109013" MODIFIED="1438894111542">
<node TEXT="to" ID="ID_1427926560" CREATED="1438894112622" MODIFIED="1438894136992"/>
<node TEXT="from" ID="ID_1299342685" CREATED="1438894137565" MODIFIED="1438894139726"/>
<node TEXT="host" ID="ID_1940612222" CREATED="1438894149545" MODIFIED="1438894152392"/>
<node TEXT="port" ID="ID_1421834508" CREATED="1438894153580" MODIFIED="1438894155503"/>
<node TEXT="secure" ID="ID_963621456" CREATED="1438894155827" MODIFIED="1438894158080"/>
<node TEXT="auth" ID="ID_151140851" CREATED="1438894171211" MODIFIED="1438894173720">
<node TEXT="username" ID="ID_1241111006" CREATED="1438894174608" MODIFIED="1438894177484"/>
<node TEXT="password" ID="ID_1856533484" CREATED="1438894177831" MODIFIED="1438894180847"/>
</node>
</node>
</node>
<node TEXT="auth" ID="ID_1159193522" CREATED="1438430522434" MODIFIED="1438541928533">
<node TEXT="path" ID="ID_972152006" CREATED="1438431514034" MODIFIED="1438431519100"/>
<node TEXT="basic %" ID="ID_1088919246" CREATED="1438430570026" MODIFIED="1438430606080">
<node TEXT="&lt;user&gt;" ID="ID_1752291987" CREATED="1438430607338" MODIFIED="1438430614200">
<node TEXT="&lt;pass&gt;" ID="ID_11631926" CREATED="1438430615909" MODIFIED="1438540795559"/>
</node>
</node>
<node TEXT="allow" ID="ID_1760299484" CREATED="1438430627848" MODIFIED="1438430641927"/>
<node TEXT="deny" ID="ID_306725017" CREATED="1438430642572" MODIFIED="1438430645143"/>
</node>
</node>
</node>
</node>
</map>
