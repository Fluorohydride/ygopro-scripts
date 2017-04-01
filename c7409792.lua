--俊足なカバ バリキテリウム
function c7409792.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,7409792)
	e1:SetCondition(c7409792.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7409792,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c7409792.condition)
	e3:SetOperation(c7409792.operation)
	c:RegisterEffect(e3)
end
function c7409792.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c7409792.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c7409792.filter(c,e,tp)
	return c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7409792.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c7409792.filter),1-tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,1-tp)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(1-tp,aux.Stringid(7409792,1)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
end
end
