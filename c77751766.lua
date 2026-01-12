--火器の祝台
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x6d)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--special counter permit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_COUNTER_PERMIT+0x6d)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.ctpermit)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.ccon1)
	e3:SetCost(s.ccost)
	e3:SetOperation(s.cop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.ccon2)
	c:RegisterEffect(e4)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x6d,5,c) end
	c:AddCounter(0x6d,5)
end
function s.ctpermit(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_CHAINING)
end
function s.cfilter1(c,loc)
	return c:IsPreviousLocation(loc) and c:GetSpecialSummonInfo(SUMMON_INFO_REASON_EFFECT)
end
function s.cfilter2(c,loc)
	return c:IsPreviousLocation(loc) and c:IsReason(REASON_EFFECT)
end
function s.ccon1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_TRAP+TYPE_SPELL)
		and eg:IsExists(s.cfilter1,1,nil,LOCATION_EXTRA)
end
function s.ccon2(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_TRAP+TYPE_SPELL)
		and eg:IsExists(s.cfilter2,1,nil,LOCATION_DECK)
end
function s.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.setfilter(c)
	return c:IsSetCard(0x1bd) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:RemoveCounter(tp,0x6d,1,REASON_EFFECT) and c:GetCounter(0x6d)==0 then
		Duel.BreakEffect()
		if Duel.Destroy(c,REASON_EFFECT)~=0 and Duel.Recover(tp,4000,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				if Duel.SSet(tp,g:GetFirst()) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_DECK,0,nil)<=1 then
					Duel.BreakEffect()
					Duel.Win(tp,0x23)
				end
			end
		end
	end
end
