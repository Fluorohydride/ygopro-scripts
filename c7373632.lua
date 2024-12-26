--神の進化
---@param c Card
function c7373632.initial_effect(c)
	aux.AddCodeList(c,21208154,62180201,57793869)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7373632.target)
	e1:SetOperation(c7373632.activate)
	c:RegisterEffect(e1)
end
function c7373632.filter(c)
	return c:IsFaceup() and (c:GetOriginalRace()&RACE_DIVINE~=0 or c:IsOriginalCodeRule(21208154,62180201,57793869)) and c:GetFlagEffect(7373632)==0
end
function c7373632.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7373632.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c7373632.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c7373632.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_INACTIVATE)
		e3:SetLabel(3)
		e3:SetValue(c7373632.effectfilter)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_DISEFFECT)
		e4:SetLabel(4)
		Duel.RegisterEffect(e4,tp)
		e3:SetLabelObject(e4)
		e4:SetLabelObject(tc)
		--chk
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_LEAVE_FIELD_P)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e0:SetLabelObject(e3)
		e0:SetOperation(c7373632.chk)
		tc:RegisterEffect(e0)
		--to grave
		local e5=Effect.CreateEffect(tc)
		e5:SetCategory(CATEGORY_TOGRAVE)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e5:SetCode(EVENT_ATTACK_ANNOUNCE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		e5:SetTarget(c7373632.tgtg)
		e5:SetOperation(c7373632.tgop)
		tc:RegisterEffect(e5)
		if not tc:IsType(TYPE_EFFECT) then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_ADD_TYPE)
			e6:SetValue(TYPE_EFFECT)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e6)
		end
		tc:RegisterFlagEffect(7373632,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(7373632,0))
	end
end
function c7373632.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c7373632.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE,1-tp)
	end
end
function c7373632.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local label=e:GetLabel()
	local tc
	if label==3 then
		tc=e:GetLabelObject():GetLabelObject()
	else
		tc=e:GetLabelObject()
	end
	return tc and tc==te:GetHandler()
end
function c7373632.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(7373632)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then
		e3:Reset()
		e4:Reset()
	else
		--reset
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(e3)
		e0:SetOperation(c7373632.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function c7373632.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	e3:Reset()
	e4:Reset()
	e:Reset()
end
