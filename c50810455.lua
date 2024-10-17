--鉄獣戦線 ケラス
---@param c Card
function c50810455.initial_effect(c)
	--special summon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50810455,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50810455)
	e1:SetCost(c50810455.spcost)
	e1:SetTarget(c50810455.sptg)
	e1:SetOperation(c50810455.spop)
	c:RegisterEffect(e1)
	--special summon from extra
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50810455,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,50810456)
	e2:SetCost(c50810455.spcost1)
	e2:SetTarget(c50810455.sptg1)
	e2:SetOperation(c50810455.spop1)
	c:RegisterEffect(e2)
end
function c50810455.cfilter(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsDiscardable()
end
function c50810455.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50810455.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c50810455.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c50810455.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50810455.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50810455.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c50810455.cfilter1(c)
	return c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST) and c:IsAbleToRemoveAsCost()
end
function c50810455.fselect(g,tg)
	return tg:IsExists(Card.IsLink,1,nil,#g)
end
function c50810455.spfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c50810455.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(c50810455.cfilter1,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(c50810455.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		if #tg==0 then return false end
		return cg:CheckSubGroup(c50810455.fselect,1,maxlink,tg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:SelectSubGroup(tp,c50810455.fselect,false,1,maxlink,tg)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50810455.spfilter1(c,e,tp,lk)
	return c50810455.spfilter(c,e,tp) and c:IsLink(lk)
end
function c50810455.spop1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(aux.NOT(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)))
	e1:SetValue(c50810455.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local lk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c50810455.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c50810455.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
