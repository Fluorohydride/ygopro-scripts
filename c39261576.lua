--パーティカル・フュージョン
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=FusionSpell.RegisterSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_MZONE,
		stage_x_operation=s.stage_x_operation,
	})
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.atkcon)
	e2:SetCost(s.atkcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end

function s.fusfilter(c)
	return c:IsSetCard(0x1047)
end

--- @type FUSION_SPELL_STAGE_X_CALLBACK_FUNCTION
function s.stage_x_operation(e,tc,tp,stage)
	if stage==FusionSpell.STAGE_AT_SUMMON_OPERATION_FINISH then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetOperation(function(ee,tpp,eg,ep,ev,re,r,rp)
			-- mark the summoned monster and raise the custom event for it
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			Duel.RaiseEvent(tc,EVENT_CUSTOM+id,e,0,tp,tp,0)
		end)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	--- bail out if summoned monster is gone
	if not (tc and tc:IsFaceup() and tc:GetFlagEffect(id)>0) then return end
	local mat=tc:GetMaterial():Filter(function (mc)
		return mc:IsSetCard(0x1047) and mc:IsAttackAbove(0) and mc:IsCanBeEffectTarget(e)
	end,nil)
	--- bail out if no valid material monster
	if #mat==0 then return end
	if chkc then return mat:IsContains(chkc) end

	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=mat:Select(tp,1,1,nil)
	Duel.SetTargetCard(g)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local sc=eg:GetFirst()
	if not (sc and sc:IsFaceup() and sc:GetFlagEffect(id)>0) then return end
	local tc=Duel.GetTargetsRelateToChain():GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	sc:RegisterEffect(e1)
end
