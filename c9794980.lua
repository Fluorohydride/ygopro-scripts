--夢幻転星イドリース
---@param c Card
function c9794980.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9794980,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9794980)
	e1:SetCondition(c9794980.spcon)
	e1:SetTarget(c9794980.sptg)
	e1:SetOperation(c9794980.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9794980,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9794981)
	e2:SetCondition(c9794980.descon)
	e2:SetTarget(c9794980.destg)
	e2:SetOperation(c9794980.desop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c9794980.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c9794980.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c9794980.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9794980.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return #g>0 and g:GetSum(Card.GetLink)>=8
end
function c9794980.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9794980.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9794980.descon(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9794980.cfilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(c9794980.cfilter,tp,0,LOCATION_MZONE,nil)
	return #g2>#g1
end
function c9794980.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9794980.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c9794980.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9794980.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c9794980.indtg(e,c)
	return c:IsLevel(9)
end
