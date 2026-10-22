--未来融合－フューチャー・フュージョン・ノヴァ
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,70095154)
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_DECK,
		additional_fcheck=s.fcheck,
		stage_x_operation=s.stage_x_op
	})
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function s.fusfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.fcheck(tp,mg,fc,mg_all)
	return mg_all:IsExists(Card.IsFusionCode,1,nil,70095154)
end
function s.stage_x_op(fe,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_ALL_OPERATION_FINISH then
		local c=fe:GetHandler()
		local fid=-1
		if tc then
			c:SetCardTarget(tc)
			fid=c:GetFieldID()
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			if c:IsOnField() and fe:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsRelateToChain() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
				e1:SetCode(EVENT_LEAVE_FIELD)
				e1:SetOperation(s.desop)
				e1:SetReset(RESET_EVENT+RESET_TOFIELD)
				c:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_SZONE)
				e2:SetCode(EVENT_LEAVE_FIELD)
				e2:SetCondition(s.descon2)
				e2:SetOperation(s.desop2)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
				c:SetCardTarget(tc)
			end
		end
		if fe:IsHasType(EFFECT_TYPE_ACTIVATE) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(1,0)
			e3:SetTarget(s.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_ATTACK)
			e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e4:SetTargetRange(LOCATION_MZONE,0)
			e4:SetTarget(s.ftarget)
			e4:SetLabel(fid)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
		end
	end
end
function s.ftarget(e,c)
	return e:GetLabel()~=c:GetFlagEffectLabel(id)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
