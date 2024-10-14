--サイバネット・カスケード
---@param c Card
function c4433488.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c4433488.target)
	e1:SetOperation(c4433488.activate)
	c:RegisterEffect(e1)
end
function c4433488.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsSummonPlayer(tp)
end
function c4433488.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g and g:IsContains(c)
end
function c4433488.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lc=eg:Filter(c4433488.cfilter,nil,tp):GetFirst()
	if chkc then return chkc:IsControler(tp) and c4433488.spfilter(chkc,e,tp,lc:GetMaterial()) end
	if chk==0 then return lc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c4433488.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,lc:GetMaterial()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c4433488.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lc:GetMaterial())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c4433488.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
