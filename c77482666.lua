--疾風の豹戦士パンサーウォリアー
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,40235813)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.recon)
	e1:SetCost(s.recost)
	e1:SetTarget(s.retg)
	e1:SetOperation(s.reop)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(s.atkcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkfilter(c)
	return c:GetPreviousTypeOnField()&TYPE_MONSTER~=0 or (not c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetOriginalType()&TYPE_MONSTER~=0)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.checkfilter,1,nil) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.cfilter(c,tp,e)
	return c:IsType(TYPE_MONSTER)
		and (Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) or
			Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp))
end
function s.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,s.cfilter,1,REASON_COST,true,e:GetHandler(),tp,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,s.cfilter,1,1,REASON_COST,true,e:GetHandler(),tp,e)
	Duel.Release(g,REASON_COST)
end
function s.tgfilter(c)
	return aux.IsCodeListed(c,40235813) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp)
	return not c:IsCode(id) and aux.IsCodeListed(c,40235813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,2),1},
			{b2,aux.Stringid(id,3),2})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TOGRAVE)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function s.atkcon(e)
	return Duel.GetFlagEffect(0,id)==0
end
