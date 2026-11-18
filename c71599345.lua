--パワー・オブ・ザ・デュエリスト
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_DRAW|CATEGORY_HANDES_SELF|CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) then
		local loc,attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_ATTRIBUTE)
		if (loc&LOCATION_MZONE+LOCATION_GRAVE)~=0 then
			local label=Duel.GetFlagEffectLabel(rp,id)
			if label then
				Duel.SetFlagEffectLabel(rp,id,label|attr)
			else
				Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1,attr)
			end
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetLabel()==2 and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	local b1=Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsPlayerCanDraw(tp,2)
	local b3=Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1),2},
			{b2,aux.Stringid(id,2),3},
			{b3,aux.Stringid(id,3),4})
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,op,ATTRIBUTE_ALL)
	e:SetLabel(op,att)
	if op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_REMOVE)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	elseif op==3 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES_SELF)
			e:SetProperty(0)
		end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES_SELF,nil,0,tp,1)
	elseif op==4 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_DISABLE)
			e:SetProperty(0)
		end
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,2,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op,att=e:GetLabel()
	if op==2 then
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToChain() then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==3 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)==d then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(p,Card.IsDiscardable,p,LOCATION_HAND,0,1,1,nil,REASON_EFFECT+REASON_DISCARD)
			if dg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.ShuffleHand(p)
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD,p)
			end
		end
	elseif op==4 then
		local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		if g:GetCount()>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local ng=g:Select(tp,2,2,nil)
			Duel.HintSelection(ng)
			for tc in aux.Next(ng) do
				if tc:IsCanBeDisabledByEffect(e) then
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e3)
					end
				end
			end
		end
	end
	local p=tp
	if op==3 then
		p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.tgop)
	e1:SetLabel(att)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,p)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetOwnerPlayer()
	local label=Duel.GetFlagEffectLabel(p,id)
	if not label or label&e:GetLabel()~=e:GetLabel() then
		Duel.Hint(HINT_CARD,0,id)
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,p,LOCATION_ONFIELD,0,nil)
		Duel.SendtoGrave(g,REASON_RULE,p)
	end
end
