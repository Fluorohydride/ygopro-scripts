--魔弾の悪魔 カスパール
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	--special summon and set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SSET+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetValue(32841045)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function s.lcheck(g)
	return g:IsExists(s.mfilter,1,nil)
end
function s.mfilter(c)
	return c:IsLinkRace(RACE_FIEND) and c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.setfilter(c,e,tp)
	if c:IsType(TYPE_MONSTER) then
		return not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
	else
		return (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
			or c:IsType(TYPE_FIELD))
			and c:IsSSetable(true)
	end
end
function s.spfilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and g:IsExists(s.setfilter,1,c,e,tp)
end
function s.gcheck(g,e,tp)
	return g:IsExists(s.spfilter,1,nil,g,e,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,nil,0x108)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:CheckSubGroup(s.gcheck,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,nil,0x108)
	if not g:CheckSubGroup(s.gcheck,2,2,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=g:SelectSubGroup(tp,s.gcheck,false,2,2,e,tp)
	if tg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:FilterSelect(tp,s.spfilter,1,1,nil,tg,e,tp)
		tg:Sub(sg)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=tg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,tc)
		else
			Duel.SSet(tp,tc,1-tp)
		end
	end
end
