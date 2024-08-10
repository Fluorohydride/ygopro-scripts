--ユニオン・アクティベーション
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.has_text_type=TYPE_UNION
function s.tgfilter(c,tp)
	return c:IsType(TYPE_NORMAL+TYPE_UNION) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,c,c:GetOriginalCodeRule(),c:GetAttack())
end
function s.thfilter(c,code,atk)
	return not c:IsOriginalCodeRule(code) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsAttack(atk) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetOriginalCodeRule(),tc:GetAttack())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.spfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,3,nil,tp)
end
function s.thfilter2(c,e,tp)
	local minc,maxc=c:GetTributeRequirement()
	return c:IsAttackAbove(3000) and c:IsSummonable(true,nil) and c:IsSummonableCard() and c:IsAbleToHand() and s.sunthfilter(c,e,tp,minc,maxc) and Duel.IsPlayerCanSummon(tp,SUMMON_TYPE_ADVANCE,c)
end
function s.sunthfilter(c,e,tp,minc,maxc)
	local e1=nil
	if s.ottg(e,c) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_SZONE,0,1,nil) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(s.otcon)
		e1:SetValue(SUMMON_TYPE_ADVANCE)
		c:RegisterEffect(e1,true)
	end
	if c:IsHasEffect(EFFECT_TRIBUTE_LIMIT,c:GetControler()) then
		local te=c:IsHasEffect(EFFECT_TRIBUTE_LIMIT,tp)
		local ev=te:GetValue()
		if not Duel.IsExistingMatchingCard(s.sunthfilter2,tp,LOCATION_MZONE,0,1,nil,e,ev) then
			return false
		end
	end
	if c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC,c:GetControler()) then
		local tte=c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC,c:GetControler())
		local ec=tte:GetCondition()
		if not ec(e,c,0) then return false end
	end
	if c:IsHasEffect(EFFECT_SUMMON_PROC,c:GetControler()) then
		local tte=c:IsHasEffect(EFFECT_SUMMON_PROC,c:GetControler())
		local ec=tte:GetCondition()
		if ec(e,c,0) then
			return true
		end
	else
		if not Duel.CheckTribute(c,minc,maxc) then return false end
	end
	if c:IsHasEffect(EFFECT_CANNOT_SUMMON,c:GetControler()) then
		return false
	end
	if e1 then e1:Reset() end
	return true
end
function s.cfilter(c)
	return c:IsCode(55521751) and not c:IsDisabled()
end
function s.otfilter(c,e,tp)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and Duel.GetMZoneCount(tp,c)>0
end
function s.otfilter2(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2
		and Duel.IsExistingMatchingCard(s.otfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.otfilter2,tp,0,LOCATION_ONFIELD,1,nil,e)
end
function s.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2
end
function s.sunthfilter2(c,e,ev)
	return ev(e,c)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsSummonable(true,nil) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		Duel.Summon(tp,tc,true,nil)
	end
end
