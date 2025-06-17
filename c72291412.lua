--DDネクロ・スライム
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion summon
	local e1=FusionSpell.CreateSummonEffect(c,{
		fusfilter=s.fusfilter,
		pre_select_mat_location=LOCATION_GRAVE,
		extra_target=s.extra_target,
		mat_operation_code_map={
			{ [LOCATION_REMOVED]=FusionSpell.FUSION_OPERATION_GRAVE },
			{ [0xff]=FusionSpell.FUSION_OPERATION_BANISH }
		},
		gc=s.gc
	})
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end

function s.fusfilter(c)
	return c:IsSetCard(0x10af)
end

function s.extra_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,tp,LOCATION_GRAVE)
end

function s.gc(e)
	return e:GetHandler()
end
