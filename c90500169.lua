--レベルダウン！？
function c90500169.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c90500169.target)
	e1:SetOperation(c90500169.activate)
	c:RegisterEffect(e1)
end
function c90500169.filter(c,e,tp)
	if c:IsFacedown() or not c:IsSetCard(0x41) or not c:IsAbleToDeck() then return false end
	local op=c:GetOwner()
	local locct=Duel.GetLocationCount(op,LOCATION_MZONE)
	local cp=c:GetControler()
	if op==cp and locct<=-1 then return false end
	if op~=cp and locct<=0 then return false end
	local code=c:GetCode()
	local class=_G["c"..code]
	return class and class.lvdncount~=nil and Duel.IsExistingMatchingCard(c90500169.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,class,e,tp,op)
end
function c90500169.spfilter(c,class,e,tp,op)
	if not c:IsControler(op) then return false end
	local code=c:GetCode()
	for i=1,class.lvdncount do
		if code==class.lvdn[i] then return c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP,op) end
	end
	return false
end
function c90500169.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c90500169.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c90500169.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c90500169.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90500169.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	local op=tc:GetOwner()
	if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCount(op,LOCATION_MZONE)<=0 then return end
	local class=_G["c"..code]
	if class==nil or class.lvdncount==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90500169.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,class,e,tp,op)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,op,true,false,POS_FACEUP)
	end
end
