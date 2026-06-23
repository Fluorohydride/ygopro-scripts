--完全なる世界 トゥーン・ワールド
local s,id,o=GetID()
function s.initial_effect(c)
	--change code
	aux.EnableChangeCode(c,15259703,LOCATION_FZONE)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(s.rmcon)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return (c:IsSetCard(0x62) or aux.IsSetNameMonsterListed(c,0x62) or aux.IsCodeListed(c,15259703))
		and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,id)<3 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove() and c:IsType(TYPE_TOON)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_CARD,0,id)
		Duel.HintSelection(tg)
		local rc=tg:GetFirst()
		if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_REMOVE)
			e2:SetTargetRange(1,0)
			e2:SetTarget(s.rmlimit)
			e2:SetLabel(rc:GetOriginalCode())
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.rmlimit(e,c,tp,r,re)
	return c:GetOriginalCode()==e:GetLabel() and re and re:GetHandler():GetOriginalCode()==id and r&REASON_EFFECT~=0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)~=0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
