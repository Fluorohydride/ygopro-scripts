--ベアルクティ－ポラリィ
function c27693363.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c27693363.sprcon)
	e2:SetTarget(c27693363.sprtg)
	e2:SetOperation(c27693363.sprop)
	c:RegisterEffect(e2)
	--activate card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27693363,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,27693363)
	e3:SetTarget(c27693363.acttg)
	e3:SetOperation(c27693363.actop)
	c:RegisterEffect(e3)
	--to hand/spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27693363,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,27693364)
	e4:SetCost(c27693363.thcost)
	e4:SetTarget(c27693363.thtg)
	e4:SetOperation(c27693363.thop)
	c:RegisterEffect(e4)
end
function c27693363.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c27693363.mnfilter(c,g)
	return g:IsExists(c27693363.mnfilter2,1,c,c)
end
function c27693363.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function c27693363.fselect(g,tp,sc)
	return g:GetCount()==2
		and g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and g:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER)
		and g:IsExists(c27693363.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c27693363.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c27693363.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c27693363.fselect,2,2,tp,c)
end
function c27693363.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c27693363.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c27693363.fselect,true,2,2,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c27693363.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local tg=e:GetLabelObject()
	Duel.SendtoGrave(tg,REASON_SPSUMMON)
	tg:DeleteGroup()
end
function c27693363.actfilter(c,tp)
	return c:IsCode(89264428) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c27693363.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27693363.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c27693363.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c27693363.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c27693363.rfilter(c,tp)
	return c:IsLevelAbove(7) and (c:IsControler(tp) or c:IsFaceup())
end
function c27693363.excostfilter(c,tp)
	return c:IsAbleToRemove() and (c:IsHasEffect(16471775,tp) or c:IsHasEffect(89264428,tp))
end
function c27693363.costfilter(c,e,tp)
	local check=Duel.GetMZoneCount(tp,c)>0
	return Duel.IsExistingMatchingCard(c27693363.tgfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,check)
end
function c27693363.tgfilter(c,e,tp,check)
	return c:IsSetCard(0x163) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c27693363.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp):Filter(c27693363.rfilter,nil,tp)
	local g2=Duel.GetMatchingGroup(c27693363.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:IsExists(c27693363.costfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:FilterSelect(tp,c27693363.costfilter,1,1,nil,e,tp)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(16471775,tp) or tc:IsHasEffect(89264428,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		aux.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function c27693363.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27693363.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,true) end
end
function c27693363.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c27693363.tgfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,check)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or not check
			or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
