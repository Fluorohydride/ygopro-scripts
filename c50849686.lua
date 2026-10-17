--閃光の封殺剣
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	local c=e:GetHandler()
	e:SetLabel(0)
	if not c:IsStatus(STATUS_ACT_FROM_HAND) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
		end
		e:SetLabel(1)
	else
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_REMOVE)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function s.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end
function s.rmfilter2(c,code)
	return (not c:IsPublic() or c:IsCode(code)) and c:IsAbleToRemove()
end
function s.thfilter(c,rc)
	return (c:IsAttribute(rc:GetAttribute())
		or c:IsRace(rc:GetRace()) or c:IsLevel(rc:GetLevel()))
		and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local rc=g:RandomSelect(1-tp,1):GetFirst()
	if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 then
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(rc)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
		if e:GetLabel()==1 and rc:IsType(TYPE_MONSTER) then
			if rc:IsLevelBelow(4) then
				local gg=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE,nil,rc:GetCode())
				if gg:IsExists(Card.IsHasEffect,1,nil,EFFECT_NECRO_VALLEY) then
					return
				end
				if (gg:GetCount()>0 or Duel.IsExistingMatchingCard(s.rmfilter2,tp,0,LOCATION_HAND+LOCATION_DECK,1,nil,rc:GetCode()))
					and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rmfilter),tp,0,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,nil,rc:GetCode())
					if rg:GetCount()>0 then
						Duel.BreakEffect()
						Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
					end
				end
			elseif rc:IsLevelAbove(5)
				and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,rc)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,rc)
				if g:GetCount()>0 then
					Duel.SendtoHand(g,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g)
				end
			end
		end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if Duel.GetTurnCount()==e:GetLabel() then return false end
	if tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
