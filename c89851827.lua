--聖秘なる竜騎士
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),true)
	--ATK down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.actcon)
	e2:SetTarget(s.acttg)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.atkval(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_REMOVED,0)*-100
end
function s.actcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.acttg(e,c)
	return c:IsRace(RACE_DRAGON+RACE_SPELLCASTER) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.tgfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsRace(RACE_DRAGON+RACE_SPELLCASTER)
		and (c:IsAbleToDeck() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.spfilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsAbleToDeck,1,c)
end
function s.racefilter(c,g)
	return c:IsRace(RACE_DRAGON) and g:IsExists(Card.IsRace,1,c,RACE_SPELLCASTER)
end
function s.fselect(g,e,tp)
	return g:IsExists(s.spfilter,1,nil,g,e,tp)
		and g:IsExists(s.racefilter,1,nil,g)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e,tp)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:CheckSubGroup(s.fselect,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	local sg=g:Filter(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),nil,e,0,tp,false,false)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:Select(tp,1,1,nil):GetFirst()
	if not sc then return end
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		g:RemoveCard(sc)
		if #g>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
	end
end
