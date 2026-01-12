--死地誤算守護
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(s.lvcon(3))
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(s.lvcon(5))
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(s.tgcon2)
	e5:SetTarget(s.tgtg2)
	e5:SetOperation(s.tgop2)
	c:RegisterEffect(e5)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_DISABLED)
	e2:SetOperation(s.tgop)
	e2:SetLabel(cid)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return end
	if e:GetOwner():IsRelateToChain(ev) then
		e:GetOwner():CancelToGrave(false)
	end
end
function s.spfilter(c,e,tp)
	return (c:IsLevel(1) or c:IsRank(1)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Equip(tp,c,tc)
			--Add Equip limit
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(s.eqlimit)
			c:RegisterEffect(e1)
		end
	end
	if c:IsOnField() and not c:GetEquipTarget() then
		c:CancelToGrave(false)
	end
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetEquipTarget() end
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc:IsLevelAbove(1) then
			e1:SetCode(EFFECT_UPDATE_LEVEL)
		else
			e1:SetCode(EFFECT_UPDATE_RANK)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function s.lvcon(lv)
	return function(e)
				local tc=e:GetHandler():GetEquipTarget()
				return tc:IsLevelAbove(lv) or tc:IsRankAbove(lv)
			end
end
function s.atkval(e,c)
	return c:GetBaseAttack()
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActivated()
end
function s.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return Duel.GetTurnPlayer()==tp
		and (tc:IsLevelAbove(7) or tc:IsRankAbove(7))
end
function s.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dg,dg:GetCount(),0,0)
end
function s.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
end
